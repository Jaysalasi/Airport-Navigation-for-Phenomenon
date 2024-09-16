import 'package:bounce/bounce.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final bool isIcon;
  const AppButton(
      {super.key,
      this.onTap,
      required this.text,
      this.color,
      this.isIcon = true});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? Colors.yellow[700],
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: text,
                isBold: false,
                color: Colors.black,
                fontSize: 14,
              ),
              const SizedBox(
                width: 10,
              ),
              if (isIcon)
                const AppIcon(
                  icon: Icons.arrow_outward_rounded,
                  color: Colors.black,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
