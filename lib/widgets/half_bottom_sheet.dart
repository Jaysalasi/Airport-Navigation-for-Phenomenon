import 'package:car_rent/widgets/app_button.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:car_rent/widgets/avatar_bottom_sheet.dart';
import 'package:car_rent/widgets/car_info_card.dart';
import 'package:car_rent/widgets/date_picker.dart';
import 'package:flutter/material.dart';

class HalfBottomSheet extends StatelessWidget {
  const HalfBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                onTap: () async {
                  // Close the current modal
                  Navigator.of(context).maybePop();

                  // Wait for 2 seconds
                  await Future.delayed(const Duration(seconds: 2));

                  // After 2 seconds, show the next bottom sheet
                  showAvatarModalBottomSheet(
                    expand: true,
                    // ignore: use_build_context_synchronously
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        const PickDateRange(), // Assuming PickDateRange is your widget
                  );
                },
              ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
