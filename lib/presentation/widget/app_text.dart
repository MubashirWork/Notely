import 'package:flutter/cupertino.dart';
import 'package:notely/core/constants/app_colors.dart';

class AppText extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  final TextOverflow overflow;
  final double letterSpacing;

  const AppText({
    required this.data,
    this.color = AppColors.black,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.align = TextAlign.start,
    this.overflow = TextOverflow.visible,
    this.letterSpacing = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(color: color, fontSize: size, fontWeight: weight, letterSpacing: letterSpacing),
      textAlign: align,
      overflow: overflow,
    );
  }
}
