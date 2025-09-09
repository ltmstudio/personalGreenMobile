import 'package:flutter/material.dart';
import 'package:hub_dom/common/widgets/main_btn.dart';
import 'package:hub_dom/common/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/src/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/src/presentation/widgets/date_widgets/date_widget.dart';
import 'package:hub_dom/src/presentation/widgets/date_widgets/time_picker_widget.dart';

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: 'Время визита', onTap: (){},),
          SizedBox(height: 20),

          TextFieldTitle(
            title: 'Дата визита',
            child: SelectDateWidget(
              onDateSelected: (v) {},
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 16),

          TextFieldTitle(
            title: 'Время визита',
            child: TimePickerWidget(
              onTimeSelected: (v) {},
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 20),

          MainButton(
            buttonTile: AppStrings.primenit,
            onPressed: () {},
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
