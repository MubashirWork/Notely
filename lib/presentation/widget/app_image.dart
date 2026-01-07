import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String image;
  final Color? color;
  final double? height;
  final double? width;

  const AppImage({
    required this.image,
    this.color,
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(image),
    color: color,
      height: height,
      width: width,
    );
  }
}
