import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Function()? onTap;
  const AppIcon(
      {super.key, required this.icon, this.size, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Icon(
        icon,
        size: size,
        color: color ?? Colors.yellow[700],
      ),
    );
  }
}
