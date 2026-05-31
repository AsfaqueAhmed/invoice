import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../configs/text_style/app_text_styles.dart';
import '../configs/theme/app_colors.dart';
import '../constants/app_decorations.dart';
import '../constants/gaps.dart';

/// The single shared text-field for the entire app.
///
/// Features:
///  - Auto light/dark theming via [AppDecorations]
///  - Optional title label with required asterisk
///  - Password toggle built-in
///  - Character counter
///  - Supports both outlined and filled (default) variants
///
/// Usage:
/// ```dart
/// AppTextField(
///   title: 'Full Name',
///   hintText: 'John Doe',
///   controller: nameCtrl,
///   prefixIcon: Icon(Icons.person_outline_rounded),
///   isRequired: true,
/// )
/// ```
enum AppTextFieldVariant { filled, outlined }

class AppTextField extends StatefulWidget {
  final String? title;
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double borderRadius;
  final bool isPassword;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final AutovalidateMode? autoValidateMode;
  final int maxLines;
  final int minLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool isRequired;
  final int? maxLength;
  final bool showCharCount;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final AppTextFieldVariant variant;
  final bool enabled;

  const AppTextField({
    super.key,
    this.title,
    required this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.borderRadius = AppDecorations.radiusSM,
    this.isPassword = false,
    this.suffixIcon,
    this.onChanged,
    this.autoValidateMode,
    this.maxLines = 1,
    this.minLines = 1,
    this.onTap,
    this.readOnly = false,
    this.isRequired = false,
    this.maxLength,
    this.showCharCount = false,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.nextFocus,
    this.variant = AppTextFieldVariant.filled,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _showPassword = false;
  late final TextEditingController _effectiveController;
  bool _ownController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _effectiveController = TextEditingController();
      _ownController = true;
    } else {
      _effectiveController = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (_ownController) _effectiveController.dispose();
    super.dispose();
  }

  InputDecoration _buildDecoration() {
    final suffixIconWidget = widget.suffixIcon ??
        (widget.isPassword
            ? GestureDetector(
                onTap: () => setState(() => _showPassword = !_showPassword),
                child: Icon(
                  _showPassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.outline,
                ),
              )
            : null);

    if (widget.variant == AppTextFieldVariant.outlined) {
      return AppDecorations.outlinedInput(
        context: context,
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: suffixIconWidget,
        borderRadius: widget.borderRadius,
      );
    }
    return AppDecorations.filledInput(
      context: context,
      hintText: widget.hintText,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIconWidget,
      borderRadius: widget.borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title row
        if (widget.title?.isNotEmpty ?? false) ...[
          RichText(
            text: TextSpan(
              text: widget.title,
              style: AppTextStyles.titleSmall.copyWith(
                color: colors.textPrimary,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: colors.error,
                    ),
                  ),
              ],
            ),
          ),
          Gaps.v8,
        ],

        // Input
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _effectiveController,
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _effectiveController,
                  focusNode: widget.focusNode,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  validator: widget.validator,
                  onChanged: (v) {
                    if (widget.maxLength != null &&
                        v.length > widget.maxLength!) {
                      final limited = v.substring(0, widget.maxLength);
                      _effectiveController.text = limited;
                      _effectiveController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: limited.length),
                      );
                    } else {
                      widget.onChanged?.call(v);
                    }
                    setState(() {});
                  },
                  onFieldSubmitted: widget.onFieldSubmitted ??
                      (_) {
                        FocusScope.of(context)
                            .requestFocus(widget.nextFocus);
                      },
                  obscureText: widget.isPassword && !_showPassword,
                  minLines: widget.minLines,
                  maxLines: widget.isPassword ? 1 : widget.maxLines,
                  autovalidateMode: widget.autoValidateMode,
                  readOnly:
                      widget.onTap != null || widget.readOnly,
                  showCursor: !widget.readOnly,
                  enabled: widget.enabled,
                  onTap: widget.onTap,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colors.textSecondary,
                  ),
                  decoration: _buildDecoration(),
                ),
                // Char count
                if (widget.showCharCount &&
                    widget.maxLength != null) ...[
                  Gaps.v4,
                  Text(
                    '${value.text.length} / ${widget.maxLength}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Labelled field wrapper matching the add_product style.
/// Wraps any input widget with a label above it.
class AppFieldLabel extends StatelessWidget {
  final String label;
  final Widget child;

  const AppFieldLabel({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
