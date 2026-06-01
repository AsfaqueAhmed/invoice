import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    return image;
  }

  static Future<String?> saveBusinessImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      final logoDir = Directory(
        '${appDir.path}/business_logos',
      );

      if (!await logoDir.exists()) {
        await logoDir.create(recursive: true);
      }

      final extension = path.extension(imageFile.path);

      final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';

      final savedFile = await imageFile.copy(
        '${logoDir.path}/$fileName',
      );

      return savedFile.path;
    } catch (e) {
      return null;
    }
  }
}
