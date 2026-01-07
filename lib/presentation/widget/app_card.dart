import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final double padding;
  final Color color;
  final Widget child;

  const AppCard({
    this.padding = 16,
    this.color = AppColors.white,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
