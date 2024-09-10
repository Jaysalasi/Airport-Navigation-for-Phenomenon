import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:bounce/bounce.dart';

class CardRow extends StatelessWidget {
  final bool isRTL;
  final Color? bgColor;
  final Color? bgColor2;
  final String text;
  final IconData? icon;
  final IconData? icon2;
  final double? size2;
  final Function()? onTap;
  final Function()? onTapIcon;
  const CardRow({
    super.key,
    required this.isRTL,
    this.bgColor,
    this.bgColor2,
    this.onTap,
    this.onTapIcon,
    required this.text,
    required this.icon,
    required this.icon2,
    required this.size2,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w * 0.9,
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: Bounce(
              onTap: onTap,
              // duration: const Duration(seconds: 3),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: bgColor ?? Colors.yellow[700],
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppIcon(
                      size: 35,
                      icon: icon!,
                      color: Colors.black,
                    ),
                    AppText(
                      text: text,
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Bounce(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Row(
                children: [
                  AppIcon(
                    icon: icon2!,
                    color: Colors.black,
                    size: size2 ?? 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
