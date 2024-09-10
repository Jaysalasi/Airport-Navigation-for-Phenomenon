import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isBold;
  const AppText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize ?? 10,
          color: color ?? Colors.white.withOpacity(isBold ? 1 : 0.7),
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}
