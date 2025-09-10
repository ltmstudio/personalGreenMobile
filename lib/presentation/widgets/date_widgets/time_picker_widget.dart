import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay)? onTimeSelected;
  final String timeFormat; // e.g., "HH:mm" or "hh:mm a"
  final String? hint;
  final Color? color;

  const TimePickerWidget({
    super.key,
    this.initialTime,
    this.onTimeSelected,
    this.timeFormat = 'HH:mm',
    this.color,
    this.hint,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.timeColor,
              onPrimary: AppColors.white,
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

    if (!mounted || pickedTime == null) return;

    setState(() => selectedTime = pickedTime);
    widget.onTimeSelected?.call(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = selectedTime != null
        ? DateFormat(widget.timeFormat).format(
      DateTime(0, 1, 1, selectedTime!.hour, selectedTime!.minute),
    )
        : widget.hint ?? AppStrings.selectTime;

    return GestureDetector(
      onTap: _pickTime,
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
                color: selectedTime != null
                    ? AppColors.primary
                    : AppColors.gray,
              ),
            ),
            const Icon(Icons.access_time, size: 18, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
