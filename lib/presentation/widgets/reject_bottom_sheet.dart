import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

class RejectBottomSheet extends StatefulWidget {
  const RejectBottomSheet({
    super.key,
    required this.onConfirm,
  });

  final Function(String rejectReason) onConfirm;

  @override
  State<RejectBottomSheet> createState() => _RejectBottomSheetState();
}

class _RejectBottomSheetState extends State<RejectBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BottomSheetTitle(title: 'Отклонить заявку?'),
            SizedBox(height: 20),
            Text(
              'Вы уверены, что хотите отклонить заявку?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 20),
            TextFieldTitle(
              title: 'Причина отклонения',
              child: KTextField(
                controller: _reasonController,
                hintText: 'Введите причину отклонения',
                isSubmitted: _isSubmitted,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Поле обязательно для заполнения';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            MainButton(
              buttonTile: AppStrings.confirm,
              onPressed: () {
                setState(() {
                  _isSubmitted = true;
                });
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onConfirm(_reasonController.text.trim());
                  Navigator.of(context).pop();
                }
              },
              isLoading: false,
            ),
            SizedBox(height: 12),
            MainButton(
              buttonTile: AppStrings.cancel,
              onPressed: () {
                Navigator.of(context).pop();
              },
              isLoading: false,
              btnColor: AppColors.lightGrayBorder,
              titleColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}









