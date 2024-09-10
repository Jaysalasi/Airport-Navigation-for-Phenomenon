import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickDateRange extends StatelessWidget {
  final DateRangePickerController? controller;
  final Function(DateRangePickerViewChangedArgs)? onViewChanged;
  final Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;
  final Function()? onCancel;
  final Function(Object?)? onSubmit;
  const PickDateRange(
      {super.key,
      this.controller,
      this.onViewChanged,
      this.onSelectionChanged,
      this.onCancel,
      this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SfDateRangePicker(
        controller: controller,
        onCancel: onCancel,
        onSelectionChanged: onSelectionChanged,
        onSubmit: onSubmit,
        onViewChanged: onViewChanged,
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
    );
  }
}
