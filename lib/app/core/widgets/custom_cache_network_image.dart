import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class CacheNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration maxAge;
  final String cacheKey;
  final int maxMemoryCacheSize;
  final double borderRadius;

  const CacheNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.maxAge = const Duration(days: 30),
    this.cacheKey = 'customImageCache',
    this.maxMemoryCacheSize = 100,
    this.borderRadius = 4,
  });

  @override
  State<CacheNetworkImage> createState() => _CacheNetworkImageState();
}

class _CacheNetworkImageState extends State<CacheNetworkImage> {
  Rx<double?> height = Rx(null);
  Rx<double?> width = Rx(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height.value = widget.height;
    width.value = widget.width;

    return FutureBuilder<Uint8List?>(
      future: CustomCacheManager.getImage(widget.imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2E3330),
            highlightColor: Colors.white,
            child: widget.placeholder?.call(context, widget.imageUrl) ??
                Container(
                  width: width.value,
                  height: height.value,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 24,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return widget.errorWidget?.call(
                context,
                widget.imageUrl,
                snapshot.error,
              ) ??
              Container(
                width: width.value,
                height: height.value,
                decoration: const BoxDecoration().copyWith(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 24,
                    color: AppColors.textTertiary,
                  ),
                ),
              );
        } else {
          var memoryImage = MemoryImage(snapshot.data!);
          if (width.value == null || height.value == null) {
            final ImageStream stream =
                memoryImage.resolve(ImageConfiguration.empty);
            stream.addListener(
                ImageStreamListener((ImageInfo info, bool synchronousCall) {
              ui.Image image = info.image;

              double width = image.width.toDouble();
              double height = image.height.toDouble();

              double aspectRatio = (height) / (width);
              if (aspectRatio != 0) {
                if (widget.height == null && widget.width != null) {
                  this.width.value = widget.width;
                  this.height.value = widget.width! * aspectRatio;
                } else if (widget.height != null && widget.width == null) {
                  this.width.value = widget.height! / aspectRatio;
                  this.height.value = widget.height;
                } else {
                  this.width.value = width;
                  this.height.value = height;
                }
              }
            }));
          }

          return Obx(
            () => ClipRect(
              child: Container(
                width: width.value,
                height: height.value,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    image: DecorationImage(
                      image: memoryImage,
                      fit: widget.fit,
                    )),
              ),
            ),
          );
        }
      },
    );
  }
}

// Enhanced CustomCacheManager with more features
class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager? _instance;

  // Memory LRU cache
  static final LinkedHashMap<String, Uint8List> memoryCache =
      LinkedHashMap<String, Uint8List>();

  static CacheManager getInstance() {
    _instance ??= CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 30),
        maxNrOfCacheObjects: 200,
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
    return _instance!;
  }

  // Utility method to clear both caches
  static Future<void> clearCache() async {
    memoryCache.clear();
    await getInstance().emptyCache();
  }

  // Get image with memory caching
  static Future<Uint8List?> getImage(String url, {int tryCount = 3}) async {
    try {
      // 1. Check memory cache first
      final memoryCachedData = memoryCache[url];
      if (memoryCachedData != null) {
        return memoryCachedData;
      }

      // 2. Try disk cache
      final fileInfo = await getInstance().getFileFromCache(url);
      if (fileInfo != null) {
        final bytes = await fileInfo.file.readAsBytes();
        memoryCache[url] = bytes;
        return bytes;
      }

      // 3. Download
      Uint8List bytes = await _download(url);
      memoryCache[url] = bytes;
      return bytes;
    } catch (e) {
      if (tryCount != 0) return getImage(url, tryCount: tryCount - 1);
      return null;
    }
  }

  static Future<Uint8List> _download(String url) async {
    final file = await getInstance().getSingleFile(url);
    final bytes = await file.readAsBytes();
    return bytes;
  }
}
