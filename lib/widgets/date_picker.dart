import 'package:car_rent/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickDateRange extends StatefulWidget {
  final DateRangePickerController? controller;
  final Function(DateRangePickerViewChangedArgs)? onViewChanged;
  final Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;
  final Function()? onCancel;
  final Function()? onContinue;
  final Function(Object?)? onSubmit;
  final String text;
  final bool endDateValue;
  const PickDateRange({
    super.key,
    this.controller,
    this.onViewChanged,
    this.onSelectionChanged,
    this.onCancel,
    this.onSubmit,
    this.endDateValue = false,
    this.text = '',
    this.onContinue,
  });

  @override
  State<PickDateRange> createState() => _PickDateRangeState();
}

class _PickDateRangeState extends State<PickDateRange> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: 500,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SfDateRangePicker(
            controller: widget.controller,
            onCancel: widget.onCancel,
            onSelectionChanged: widget.onSelectionChanged,
            onSubmit: widget.onSubmit,
            onViewChanged: widget.onViewChanged,
            navigationDirection: DateRangePickerNavigationDirection.vertical,
            enableMultiView: true,
            enablePastDates: false,
            // allowViewNavigation: true,
            navigationMode: DateRangePickerNavigationMode.scroll,
            // view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            backgroundColor: Colors.white,
            headerStyle:
                const DateRangePickerHeaderStyle(backgroundColor: Colors.white),
            yearCellStyle: const DateRangePickerYearCellStyle(),
            monthViewSettings: const DateRangePickerMonthViewSettings(),
            monthCellStyle: DateRangePickerMonthCellStyle(
              todayCellDecoration: BoxDecoration(
                color: Colors.yellow[700],
                shape: BoxShape.circle,
              ),
            ),
            initialDisplayDate: DateTime.now(),
            // extendableRangeSelectionDirection = ExtendableRangeSelectionDirection.both,
            // initialSelectedRange: PickerDateRange(
            //     DateTime.now().subtract(const Duration(days: 4)),
            //     DateTime.now().add(const Duration(days: 3))),
          ),
        ),
        if (widget.endDateValue)
          Align(
            alignment: Alignment.bottomCenter,
            child: AppButton(
              text: widget.text,
              onTap: widget.onContinue,
            ).paddingSymmetric(
              // horizontal: 20,
              vertical: 20,
            ),
          )
      ],
    );
  }
}
