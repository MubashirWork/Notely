import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {

  final Color color;
  const LoadingIndicator({this.color = AppColors.white, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      width: 18,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 1.3,
      ),
    );
  }
}
