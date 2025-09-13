import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

class CreatePerformerWidget extends StatelessWidget {
  const CreatePerformerWidget({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl, required this.onAdded,
  });

  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final ValueChanged<(String, String)> onAdded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: 'Выберите контактное лицо'),

          SizedBox(height: 12),

          TextFieldTitle(
            title: 'Контактное лицо',
            child: KTextField(
              controller: nameCtrl,
              isSubmitted: false,
              keyboardType: TextInputType.number,
              hintText: AppStrings.phoneHintText,
              borderColor: AppColors.lightGrayBorder,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          TextFieldTitle(
            title: AppStrings.phoneContactPerson,
            child: KTextField(
              controller: phoneCtrl,
              isSubmitted: false,
              maxLength: 10 ,
              keyboardType: TextInputType.number,
              hintText: AppStrings.phoneHintText,
              borderColor: AppColors.lightGrayBorder,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          MainButton(
            buttonTile: AppStrings.save,
            onPressed: () {
              onAdded((nameCtrl.text.trim(), phoneCtrl.text.trim()));

              Navigator.pop(context);

            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
