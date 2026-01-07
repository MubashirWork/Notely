import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final Widget child;
  const ProfileCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: child,
    );
  }
}
