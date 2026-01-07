import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/presentation/widget/app_text.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;
  final VoidCallback? iconClick;
  final String titleText;
  final List<Widget>? widgets;

  const Appbar({required this.titleText, this.icon, this.iconClick, this.widgets, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: icon != null
          ? GestureDetector(
              onTap: icon != null ? iconClick : null,
              child: Icon(icon, color: Colors.white),
            )
          : null,
      title: AppText(
        data: titleText,
        color: AppColors.white,
        size: 18,
        weight: FontWeight.w600,
      ),
      backgroundColor: AppColors.royalBlue,
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
