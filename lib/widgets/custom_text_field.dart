import 'package:flutter/material.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';

class CustomTextField extends StatefulWidget{
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final Color borderColor;
  final Color? fillColor;
  final bool filled;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.fillColor,
    this.filled = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted
  });

  @override
  State createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField>{


  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        style: widget.textStyle ?? AppFonts.beVietnamLight14.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          labelStyle: widget.labelStyle,
          hintStyle: widget.hintStyle ?? AppFonts.beVietnamLight14.copyWith(color: AppColors.textSecondary),
          prefixIcon: (widget.prefixIcon != null)? Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 6),
            child: widget.prefixIcon,
          ) : null,
          suffixIcon: (widget.suffixIcon != null)? Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 6, left: 4),
            child: widget.suffixIcon,
          ) : null,
          filled: widget.filled,
          fillColor: widget.fillColor,
          contentPadding: widget.contentPadding,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(color: AppColors.warning, width: 2),
          ),
        ),
    );
  }
}