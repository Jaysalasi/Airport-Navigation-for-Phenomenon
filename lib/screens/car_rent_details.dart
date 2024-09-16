import 'package:animate_do/animate_do.dart';
import 'package:car_rent/screens/route_map.dart';
import 'package:car_rent/widgets/app_button.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:car_rent/widgets/car_info_card.dart';
import 'package:car_rent/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CarRentDetails extends StatefulWidget {
  final dynamic details;
  const CarRentDetails({super.key, required this.details});

  @override
  State<CarRentDetails> createState() => _CarRentDetailsState();
}

class _CarRentDetailsState extends State<CarRentDetails> {
  bool showFirstModal = true;
  bool showSecondModal = false;
  bool showThirdModal = false;
  bool endDateValue = false;
  String days = '';
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  calculateDaysBetween(DateTime startDate, DateTime endDate) {
    // Calculate the difference
    final difference = endDate.difference(startDate).inDays;
    return difference;
  }

  void _navigateWithFade(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RouteMapScreen(),
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
        // actionsIconTheme: IconThemeData(color: Colors.yellow[700]),
        // automaticallyImplyLeading: true,
        leading: AppIcon(
          icon: Icons.arrow_back,
          size: 20,
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        // fit: StackFit.expand,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: context.width,
                    child: Image.asset(
                      widget.details['image'],
                    ),
                  ),
                  AppText(
                    text: widget.details['rating'],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    text: widget.details['name'],
                    fontSize: 20,
                    isBold: true,
                  ),
                  const AppText(
                    text: 'lorem ipsum takw me there and now',
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeInUp(
              animate: showFirstModal,
              child: Container(
                width: context.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Information',
                          isBold: false,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            AppText(
                              color: Colors.black,
                              text: 'Rental Terms',
                              fontSize: 14,
                            ),
                            AppIcon(
                              icon: Icons.arrow_outward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CarInfoCard(
                          icon: Icons.garage_rounded,
                          subText: 'Gearbox',
                          text: 'Automatic',
                          color: Colors.grey[350],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CarInfoCard(
                          icon: Icons.gas_meter_outlined,
                          subText: 'Fuel usage',
                          text: '7.2 liters',
                          color: Colors.green[300],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CarInfoCard(
                          icon: Icons.directions_car_outlined,
                          subText: 'Full tank range',
                          text: '800 km',
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          color: Colors.blueGrey[900],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      text: 'Book from \$100/day',
                      color: Colors.yellow[700],
                      onTap: () {
                        setState(() {
                          showFirstModal = false;
                          showSecondModal = true;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showSecondModal)
            Positioned.fill(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeInUp(
                delay: const Duration(seconds: 1),
                animate: showSecondModal,
                child: Container(
                  width: context.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Stack(
                    children: [
                      PickDateRange(
                        onContinue: () {
                          setState(() {
                            showSecondModal = false;
                            showThirdModal = true;
                          });
                        },
                        text: 'Confirm reservation for \$ $days',
                        endDateValue: endDateValue,
                        controller: dateRangePickerController,
                        onViewChanged: (p0) {
                          // print('range stuff ${p0.visibleDateRange}');
                        },
                        onSelectionChanged: (p0) {
                          final PickerDateRange pickerDateRange = p0.value!;
                          final DateTime? startDate = pickerDateRange.startDate;
                          final DateTime? endDate = pickerDateRange.endDate;

                          if (endDate != null) {
                            final dayss =
                                calculateDaysBetween(startDate!, endDate);
                            final price = dayss * 50;
                            // print('dayss = $price');
                            setState(() {
                              endDateValue = true;
                              days = price.toString();
                            });
                          }
                          // update();
                          // print(
                          //     'end valve $endDateValue ${dateRangePickerController.selectedRange}');
                        },
                      ).animate().fadeIn(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 500),
                          ),
                      // : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          if (showThirdModal)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeInUp(
                curve: Curves.easeIn,
                delay: const Duration(seconds: 3),
                animate: showThirdModal,
                child: Container(
                  width: context.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Information',
                            isBold: false,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              AppText(
                                color: Colors.black,
                                text: 'Rental Terms',
                                fontSize: 14,
                              ),
                              AppIcon(
                                icon: Icons.arrow_outward_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CarInfoCard(
                              icon: Icons.gas_meter_outlined,
                              subText: 'Period',
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              text: 'jan 9 - Jan 20',
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CarInfoCard(
                              icon: Icons.attach_money_rounded,
                              subText: 'Full tank range',
                              text: '\$ $days',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            isIcon: false,
                            text: 'Cancel Booking',
                            color: Colors.grey[300],
                            onTap: () {
                              setState(
                                () {
                                  showThirdModal = false;
                                },
                              );
                            },
                          ),
                          AppButton(
                            text: 'Build a route',
                            color: Colors.yellow[700],
                            onTap: () {
                              _navigateWithFade(
                                context,
                              );
                              setState(
                                () {
                                  // showFirstModal =
                                  //     false; // Update the state as needed
                                  // showSecondModal =
                                  //     true; // Update the state as needed
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
