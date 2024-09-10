import 'package:animate_do/animate_do.dart';
import 'package:car_rent/widgets/app_button.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:car_rent/widgets/avatar_bottom_sheet.dart';
import 'package:car_rent/widgets/car_info_card.dart';
import 'package:car_rent/widgets/date_picker.dart';
import 'package:car_rent/widgets/half_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CarRentDetails extends StatefulWidget {
  final dynamic details;
  const CarRentDetails({super.key, required this.details});

  @override
  State<CarRentDetails> createState() => _CarRentDetailsState();
}

class _CarRentDetailsState extends State<CarRentDetails> {
  bool showFirstModal = true;
  bool endDateValue = false;
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // openHalfModal();
      // setState(() {
      //   showFirstModal = true;
      // });
    });
  }

  void openHalfModal() {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const HalfBottomSheet(),
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
            // print('tap');
            Get.back();
            // setState(() {
            //   // showDate = true;
            //   showFirstModal = !showFirstModal;
            // });
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
                        // First, update the state and then show the modal
                        setState(() {
                          showFirstModal = false; // Update the state as needed
                        });

                        showAvatarModalBottomSheet(
                          onCancel: () {
                            // print('end valve $endDateValue');
                            setState(() {
                              showFirstModal =
                                  !showFirstModal; // Toggle the state as needed
                            });
                          },
                          isEndDate: endDateValue,
                          expand: true,
                          text: 'Confirm reservation for ',
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Stack(
                            children: [
                              PickDateRange(
                                controller: dateRangePickerController,
                                onViewChanged: (p0) {
                                  print('range stuff ${p0.visibleDateRange}');
                                },
                                onSelectionChanged: (p0) {
                                  final PickerDateRange pickerDateRange =
                                      p0.value!;
                                  final DateTime? startDate =
                                      pickerDateRange.startDate;
                                  final DateTime? endDate =
                                      pickerDateRange.endDate;

                                  setState(() {
                                    endDateValue = true;
                                  });
                                  print(
                                      'end valve $endDateValue ${dateRangePickerController.selectedRange}');
                                },
                              ).animate().fadeIn(
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 500),
                                  ),
                              if (endDateValue)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AppButton(
                                    text: 'text',
                                    onTap: () {},
                                  ).paddingSymmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                )
                              // : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
          // .animate().slide(
          //     curve: Curves.easeIn,
          //     duration: const Duration(seconds: 1),
          //     begin: const Offset(0, 10.0)),
          // showDate
          // ? Positioned.fill(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: Container(
          //       width: context.width,
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(20),
          //             topRight: Radius.circular(20)),
          //       ),
          //       padding: const EdgeInsets.only(
          //         left: 20.0,
          //         right: 20.0,
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const SizedBox(
          //             height: 40,
          //           ),
          //           const PickDateRange(),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           AppButton(
          //             text: 'Select Date',
          //             color: Colors.yellow[700],
          //             onTap: () {
          //               setState(() {
          //                 showDate = false;
          //               });
          //             },
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
          // : const SizedBox.shrink(),
          // const SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }
}
