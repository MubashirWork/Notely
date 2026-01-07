import 'package:flutter/material.dart';
import 'package:notely/presentation/widget/app_text.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final Color color;

  const AppTextButton({required this.onClick, required this.text, this.color = Colors.white, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        overlayColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AppText(
        data: text,
        color: color,
        weight: FontWeight.w500,
        align: TextAlign.center,
      ),
    );
  }
}
