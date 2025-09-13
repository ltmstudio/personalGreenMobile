import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/date_widgets/date_widget.dart';
import 'package:hub_dom/presentation/widgets/date_widgets/time_picker_widget.dart';

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({
    super.key,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onClear,
  });

  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<TimeOfDay> onSelectTime;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.visitTime, onClear: onClear),
          SizedBox(height: 20),

          TextFieldTitle(
            title: AppStrings.visitDate,
            child: SelectDateWidget(
              onDateSelected: (v) {
                onSelectDate(v);
              },
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 16),

          TextFieldTitle(
            title: AppStrings.visitTime,
            child: TimePickerWidget(
              onTimeSelected: (v) {
                onSelectTime(v);
              },
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 20),

          MainButton(
            buttonTile: AppStrings.primenit,
            onPressed: () {
              context.pop();
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
