import 'package:car_rent/constants/constants.dart';
import 'package:car_rent/screens/car_rent_details.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:car_rent/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarRent extends StatefulWidget {
  const CarRent({super.key});

  @override
  State<CarRent> createState() => _CarRentState();
}

class _CarRentState extends State<CarRent> {
  List bmw = [
    {
      'name': 'BMW - x5',
      'rate': '200',
      'rating': '5',
      'image': AppImages.bmw,
    },
    {
      'name': 'BMW - x7',
      'rate': '300',
      'rating': '5',
      'image': AppImages.bmw,
    },
    {
      'name': 'BMW - 8',
      'rate': '600',
      'rating': '5',
      'image': AppImages.bmw,
    },
  ];
  List audi = [
    {
      'name': 'Audi - A1',
      'rate': '300',
      'rating': '5',
      'image': AppImages.audi,
    },
    {
      'name': 'Audi - A4',
      'rate': '300',
      'rating': '5',
      'image': AppImages.audi,
    },
    {
      'name': 'Audi - A8',
      'rate': '300',
      'rating': '5',
      'image': AppImages.audi,
    },
    {
      'name': 'Audi - Q5',
      'rate': '300',
      'rating': '5',
      'image': AppImages.audi,
    },
    {
      'name': 'Audi - Q8',
      'rate': '300',
      'rating': '5',
      'image': AppImages.audi,
    },
  ];

  void _navigateWithFade(BuildContext context, Object e) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CarRentDetails(
          details: e,
        ),
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return FadeTransition(
            opacity: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const AppIcon(
            icon: Icons.arrow_back,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'Car rent',
                  isBold: true,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                AppText(
                  text: 'Filters',
                  color: Colors.yellow[700],
                  fontSize: 16,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'BMW',
                  isBold: false,
                  fontSize: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    AppText(
                      text: 'View all',
                      fontSize: 16,
                    ),
                    AppIcon(
                      icon: Icons.arrow_outward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Row(
                children: bmw.map(
                  (e) {
                    return CarCard(
                      onTap: () {
                        // Get.to(
                        //   () => CarRentDetails(
                        //     details: e,
                        //   ),
                        // );
                        _navigateWithFade(context, e);
                      },
                      image: e['image'],
                      rating: e['rating'],
                      name: e['name'],
                      price: e['rate'],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Audi',
                  isBold: false,
                  fontSize: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    AppText(
                      text: 'View all',
                      fontSize: 16,
                    ),
                    AppIcon(
                      icon: Icons.arrow_outward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: audi.map(
                  (e) {
                    return CarCard(
                      onTap: () {
                        // Get.to(
                        //   () => CarRentDetails(
                        //     details: e,
                        //   ),
                        // );
                        _navigateWithFade(context, e);
                      },
                      image: e['image'],
                      rating: e['rating'],
                      name: e['name'],
                      price: e['rate'],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
