import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CarInfoCard extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final IconData icon;
  final String subText;
  final String text;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  const CarInfoCard(
      {super.key,
      this.color,
      required this.icon,
      required this.subText,
      required this.text,
      this.textColor,
      this.iconColor,
      this.mainAxisAlignment,
      this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(
              height: 5,
            ),
            AppText(
              text: subText,
              fontSize: 11,
              color: textColor ?? Colors.black,
            ),
            AppText(
              text: text,
              color: textColor ?? Colors.black,
              fontSize: 14,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
