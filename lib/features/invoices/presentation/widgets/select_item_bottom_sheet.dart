import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/extensions/string_extensions.dart';
import 'package:get/get.dart';

class AppSelectBottomSheet<T> extends StatelessWidget {
  final String title;

  final List<T> items;
  final T? selectedItem;

  final String Function(T item) titleBuilder;
  final String Function(T item)? subtitleBuilder;
  final String Function(T item)? avatarBuilder;
  final String Function(T item)? filePathBuilder;

  final VoidCallback onAddTap;
  final String addTitle;
  final String addSubtitle;

  final void Function(T item) onSelect;

  const AppSelectBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.titleBuilder,
    required this.onSelect,
    required this.onAddTap,
    required this.addTitle,
    required this.addSubtitle,
    this.subtitleBuilder,
    this.avatarBuilder,
    this.filePathBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return AppBottomSheet(
          title: title,
          onClose: Get.back,
          child: Column(
            children: [
              AppSearchField(
                hintText: "Search...",
                onChanged: (_) {},
              ),
              AppActionCard(
                icon: Icons.add,
                title: addTitle,
                subtitle: addSubtitle,
                onTap: onAddTap,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final selected = item == selectedItem;

                    return _GenericTile<T>(
                      item: item,
                      selected: selected,
                      title: titleBuilder(item),
                      subtitle: subtitleBuilder?.call(item),
                      avatar: avatarBuilder?.call(item),
                      filePath: filePathBuilder?.call(item),
                      onTap: () => onSelect(item),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GenericTile<T> extends StatelessWidget {
  final T item;
  final bool selected;

  final String title;
  final String? subtitle;
  final String? avatar;
  final String? filePath;

  final VoidCallback onTap;

  const _GenericTile({
    required this.item,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.avatar,
    required this.filePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              if (avatar.notNullNotEmpty || filePath.notNullNotEmpty)
                _Avatar(
                  avatar: avatar,
                  filePath: filePath,
                ),
              if (avatar.notNullNotEmpty || filePath.notNullNotEmpty)
                const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onClose;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(child: child),
        ],
      ),
    );
  }
}

class AppActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AppActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primaryContainer,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatar;
  final String? filePath;

  const _Avatar({required this.avatar, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        shape: BoxShape.circle,
      ),
      child: filePath.notNullNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.file(
                File(filePath!),
                fit: BoxFit.cover,
              ),
            )
          : avatar.notNullNotEmpty
              ? Text(
                  avatar!.toUpperCase(),
                  style: theme.textTheme.labelLarge,
                )
              : const SizedBox(),
    );
  }
}
