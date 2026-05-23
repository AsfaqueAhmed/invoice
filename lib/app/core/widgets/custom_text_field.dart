import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_app/app/core/configs/text_style/app_text_styles.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
class CustomTextFormField extends StatefulWidget {
  final String? title;
  final String hintText;
  final String? iconImage;
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
  final double verticalPadding;
  final VoidCallback? onTap;
  final bool isViewOnly;
  final bool isRequired;
  final int? maxLength;
  final bool showCharCount;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefixIcon;
  final double? prefixIconMaxHeight;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  const CustomTextFormField({
    super.key,
    this.title,
    required this.hintText,
    this.iconImage,
    this.controller,
    this.validator,
    this.borderRadius = 8,
    this.isPassword = false,
    this.suffixIcon,
    this.onChanged,
    this.autoValidateMode,
    this.maxLines = 1,
    this.minLines = 1,
    this.verticalPadding = 12,
    this.onTap,
    this.isViewOnly = false,
    this.isRequired = false,
    this.maxLength,
    this.showCharCount = false,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.prefixIconMaxHeight,
    this.keyboardType,
    this.inputFormatters,
    this.fillColor,
    this.focusNode,
    this.nextFocus,
    this.labelText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showPassword = false;

  void handleVisibilityClick() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title?.isNotEmpty ?? false)
          RichText(
            text: TextSpan(
              text: widget.title,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textPrimary
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: " *",
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        if (widget.title?.isNotEmpty ?? false) Gaps.v8,
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller ?? TextEditingController(),
          builder: (context, value, _) {
            final currentLength = value.text.length;
            return Column(
              children: [
                TextFormField(
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  controller: widget.controller,
                  validator: widget.validator ??
                      (value) {
                        return null;
                      },
                  onChanged: (value) {
                    if (widget.maxLength != null &&
                        value.length > widget.maxLength!) {
                      final limited = value.substring(0, widget.maxLength);
                      widget.controller?.text = limited;
                      widget.controller?.selection = TextSelection.fromPosition(
                        TextPosition(offset: limited.length),
                      );
                    } else {
                      widget.onChanged?.call(value);
                    }
                    setState(() {});
                  },
                  onFieldSubmitted: widget.onFieldSubmitted ??
                      (_) {
                        FocusScope.of(context).requestFocus(widget.nextFocus);
                      },
                  obscureText: widget.suffixIcon == null
                      ? widget.isPassword
                          ? showPassword
                              ? false
                              : true
                          : widget.isPassword
                      : widget.isPassword,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary
                  ),
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  autovalidateMode: widget.autoValidateMode,
                  readOnly: widget.onTap != null || widget.isViewOnly,
                  showCursor: !widget.isViewOnly,
                  focusNode: widget.focusNode,
                  onTap: widget.onTap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.fillColor ?? AppColors.white,
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: widget.verticalPadding,
                      horizontal: 12,
                    ),
                    prefixIcon: widget.prefixIcon ??
                        (widget.iconImage != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 8,
                                ),
                                child: Image.asset(
                                  widget.iconImage ?? '',
                                  color: widget.isViewOnly
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade500,
                                  height: widget.prefixIconMaxHeight ?? 16,
                                  width: widget.prefixIconMaxHeight ?? 16,
                                ),
                              )
                            : null),
                    prefixIconConstraints: BoxConstraints(
                      maxHeight: widget.prefixIconMaxHeight ?? 16,
                    ),
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xff6F7A70).withValues(alpha: .5),
                    ),
                    suffixIcon: widget.suffixIcon ??
                        (widget.isPassword
                            ? GestureDetector(
                                onTap: () {
                                  handleVisibilityClick();
                                },
                                child: Icon(
                                  showPassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off,
                                  size: 18,
                                  color: AppColors.grey400,
                                ),
                              )
                            : null),
                    errorStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                          color: const Color(0xffBFC9BE).withValues(alpha: .3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                          color: Color(0xffBFC9BE).withValues(alpha: .3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                          color: Color(0xffBFC9BE).withValues(alpha: .3)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(color:AppColors.error,),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(color: AppColors.error,),
                    ),
                  ),
                ),
                if (widget.showCharCount && widget.maxLength != null) ...[
                  Gaps.v8,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$currentLength / ${widget.maxLength}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xff99A0AE),
                      ),
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
