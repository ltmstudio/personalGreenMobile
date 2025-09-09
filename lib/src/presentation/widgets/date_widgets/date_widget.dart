import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:intl/intl.dart';

class SelectDateWidget extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final String dateFormat;
  final bool includeTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hint;
  final Color? color;

  const SelectDateWidget({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.dateFormat = 'dd.MM.yyyy',
    this.includeTime = false,
    this.firstDate,
    this.lastDate,
    this.color,
    this.hint,
  });

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.timeColor,
              onPrimary: AppColors.white ,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedDate == null) return;

    DateTime finalDate = pickedDate;

    if (widget.includeTime) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate ?? now),
      );

      if (!mounted) return;

      if (pickedTime != null) {
        finalDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    if (!mounted) return;

    setState(() => selectedDate = finalDate);
    widget.onDateSelected?.call(finalDate);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = selectedDate != null
        ? DateFormat(widget.dateFormat).format(selectedDate!)
        : widget.hint ?? AppStrings.selectDate;

    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightGrayBorder),

          color: widget.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: selectedDate != null
                    ? AppColors.primary
                    : AppColors.gray,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
