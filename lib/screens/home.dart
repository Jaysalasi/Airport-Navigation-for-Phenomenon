import 'package:car_rent/screens/car_rent.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:car_rent/widgets/card_row.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List destinations = [
    {
      'location': 'Nigeria = Singapore',
      'date': '10 Sept 2024',
      'gate': 'Gate 14',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 4',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 4',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 2',
    },
    {
      'location': 'Nigeria = Singapore',
      'date': '10 Sept 2024',
      'gate': 'Gate 14',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 4',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 4',
    },
    {
      'location': 'Nigeria = New York',
      'date': '12 Sept 2024',
      'gate': 'Gate 2',
    },
  ];

  void _navigateWithFade() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CarRent(),
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
      // appBar: AppBar(
      //   title: AppText(
      //     text: 'Good afternoon!',
      //     fontSize: 18,
      //     color: Colors.white.withOpacity(0.6),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Good afternoon!',
                fontSize: 18,
                color: Colors.white.withOpacity(0.6),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Airport map',
                    isBold: true,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  AppIcon(
                    icon: Icons.arrow_outward_rounded,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const CardRow(
                isRTL: false,
                text: 'Transfer',
                icon: Icons.panorama_fish_eye_rounded,
                icon2: Icons.bed,
                bgColor: null,
                size2: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              CardRow(
                isRTL: true,
                text: 'Tickets',
                icon: Icons.airplane_ticket_rounded,
                icon2: Icons.view_carousel_rounded,
                bgColor: Colors.red[700],
                size2: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              CardRow(
                onTap: () {
                  // Get.to(() => const CarRent());
                  _navigateWithFade();
                  // print('car rent');
                },
                isRTL: false,
                text: 'Car Rent',
                icon: Icons.car_rental_rounded,
                icon2: Icons.chat_rounded,
                bgColor: Colors.green[700],
                size2: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Upcoming departures',
                    isBold: false,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      AppText(text: 'View all'),
                      AppIcon(
                        icon: Icons.arrow_outward_rounded,
                        size: 20,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: destinations.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: e['location'],
                            isBold: true,
                            fontSize: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: e['date'],
                                // fontSize: 20,
                              ),
                              AppText(
                                text: e['gate'],
                                // fontSize: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
