import 'dart:math';

import 'package:car_rent/widgets/app_button.dart';
import 'package:car_rent/widgets/app_icon.dart';
import 'package:car_rent/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as modal_bottom_sheet;

class AvatarBottomSheet extends StatefulWidget {
  final Function()? onCancel;
  final Function()? onTap;
  final Widget child;
  final String? text;
  final bool isEndDate;
  final Animation<double> animation;
  final SystemUiOverlayStyle? overlayStyle;

  const AvatarBottomSheet(
      {super.key,
      required this.child,
      required this.animation,
      this.overlayStyle,
      this.onCancel,
      this.onTap,
      this.text,
      required this.isEndDate});

  @override
  State<AvatarBottomSheet> createState() => _AvatarBottomSheetState();
}

class _AvatarBottomSheetState extends State<AvatarBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.overlayStyle ?? SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            SafeArea(
              bottom: false,
              child: AnimatedBuilder(
                animation: widget.animation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, (1 - widget.animation.value) * 100),
                  child: Opacity(
                    opacity: max(0, widget.animation.value * 2 - 1),
                    child: child,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Row(
                        children: [
                          AppIcon(
                            icon: Icons.calendar_month_rounded,
                            size: 14,
                          ),
                          SizedBox(width: 20),
                          AppText(
                            text: 'How long will you use the car?',
                            fontSize: 12,
                            isBold: true,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: AppIcon(
                          icon: Icons.close_rounded,
                          onTap: () {
                            // if (onCancel != null) {
                            widget.onCancel!();
                            // }
                            Navigator.pop(context);
                            // print('cancel');
                          },
                          color: Colors.black,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: context.height * 0.86,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Stack(
                      children: [
                        // The child widget you pass should be used here
                        widget.child,
                        if (widget.isEndDate)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AppButton(
                              text: widget.text!,
                              onTap: () {},
                            ).paddingSymmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showAvatarModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Function()? onCancel,
  Function()? onTap,
  Color? backgroundColor,
  double? elevation,
  bool isEndDate = false,
  ShapeBorder? shape,
  String? text,
  Clip? clipBehavior,
  Color barrierColor = Colors.black87,
  bool bounce = true,
  bool expand = false,
  AnimationController? secondAnimation,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Duration? duration,
  SystemUiOverlayStyle? overlayStyle,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final result = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push(modal_bottom_sheet.ModalSheetRoute<T>(
    builder: builder,
    containerBuilder: (_, animation, child) => AvatarBottomSheet(
      onCancel: onCancel,
      onTap: onTap,
      text: text,
      animation: animation,
      overlayStyle: overlayStyle,
      isEndDate: isEndDate,
      child: child,
    ),
    bounce: bounce,
    secondAnimationController: secondAnimation,
    expanded: expand,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    enableDrag: enableDrag,
    duration: duration,
  ));
  return result;
}
