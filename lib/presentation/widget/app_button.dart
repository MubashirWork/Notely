import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double radius;
  final Color borderColor;
  final double minWidth;

  const AppButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor = AppColors.mediumBlue,
    this.horizontalPadding = 14,
    this.verticalPadding = 12,
    this.radius = 8,
    this.borderColor = AppColors.royalBlue,
    this.minWidth = double.infinity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor, width: 1),
        ),
        minimumSize: Size(minWidth, 5),
      ),
      child: child,
    );
  }
}
