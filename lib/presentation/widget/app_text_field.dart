import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/presentation/widget/app_text.dart';

class AppTextField extends StatelessWidget {
  final IconData? prefix;
  final IconData? suffix;
  final VoidCallback? suffixOnClick;
  final TextEditingController controller;
  final Color filledColor;
  final double radius;
  final int maxLines;
  final String hint;
  final double horizontalPadding;
  final double verticalPadding;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Color borderColor;
  final bool readOnly;

  const AppTextField({
    this.prefix,
    this.suffix,
    this.suffixOnClick,
    required this.controller,
    this.filledColor = AppColors.lightGrey,
    this.radius = 8,
    this.maxLines = 1,
    this.hint = "",
    this.horizontalPadding = 14,
    this.verticalPadding = 12,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.borderColor = AppColors.lightGrey,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(fontSize: 14, color: AppColors.black),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefix != null ? Icon(prefix, color: Colors.black54) : null,
        suffixIcon: suffix != null
            ? GestureDetector(
                onTap: suffixOnClick,
                child: Icon(suffix, color: Colors.black54),
              )
            : null,
        filled: true,
        fillColor: filledColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor),
        ),
        hint: AppText(data: hint, size: 14, overflow: TextOverflow.ellipsis),
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
    );
  }
}
