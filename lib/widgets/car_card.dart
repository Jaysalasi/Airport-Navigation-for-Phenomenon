import 'package:bounce/bounce.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final String image;
  final String rating;
  final String name;
  final String price;
  final Function()? onTap;

  const CarCard({
    super.key,
    required this.image,
    required this.rating,
    required this.name,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 170,
        margin: const EdgeInsets.only(
          right: 12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 12.0,
            bottom: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText(
                text: rating,
                color: Colors.black,
                isBold: true,
                // fontSize: ,
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(image),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text: name,
                color: Colors.black,
                isBold: true,
                fontSize: 18,
              ),
              AppText(
                text: price,
                color: Colors.black,
                isBold: true,
                // fontSize: ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
