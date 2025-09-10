import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:intl/intl.dart';


class SelectDateRangeWidget extends StatefulWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTimeRange)? onDateRangeSelected;

  const SelectDateRangeWidget({
    super.key,
    this.firstDate,
    this.lastDate,
    this.onDateRangeSelected,
  });

  @override
  State<SelectDateRangeWidget> createState() => _SelectDateRangeWidgetState();
}

class _SelectDateRangeWidgetState extends State<SelectDateRangeWidget> {
  DateTimeRange? selectedDateRange;

  String get formattedRange {
    if (selectedDateRange == null) return AppStrings.selectDate;
    return "${DateFormat('dd.MM.yyyy').format(selectedDateRange!.start)} – "
        "${DateFormat('dd.MM.yyyy').format(selectedDateRange!.end)}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightGrayBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formattedRange, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:  selectedDateRange != null ? AppColors.primary : AppColors.gray
            )),
            const Icon(Icons.calendar_today, size: 18, color: AppColors.gray),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? now,
      lastDate: widget.lastDate ?? DateTime(2100),
      initialDateRange: selectedDateRange != null
          ? DateTimeRange(
        start: selectedDateRange!.start,
        end: selectedDateRange!.end,
      )
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedRange == null) return;

    setState(() => selectedDateRange = pickedRange);
    widget.onDateRangeSelected?.call(pickedRange);
  }
}