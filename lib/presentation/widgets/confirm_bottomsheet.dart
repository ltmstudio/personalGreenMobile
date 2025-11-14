import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';

import 'buttons/main_btn.dart';
import 'bottom_sheet_widget.dart';

class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
    this.confirmButtonText,
    this.cancelButtonText,
  });

  final String title;
  final String body;
  final VoidCallback onTap;
  final String? confirmButtonText;
  final String? cancelButtonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTitle(title: title),
          SizedBox(height: 20),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          MainButton(
            buttonTile: confirmButtonText ?? AppStrings.confirm,
            onPressed: () {
              // Сначала вызываем onTap, потом закрываем диалог
              onTap();
              Navigator.of(context).pop();
            },
            isLoading: false,
          ),
          if (cancelButtonText != null) ...[
            SizedBox(height: 12),
            MainButton(
              buttonTile: cancelButtonText!,
              onPressed: () {
                Navigator.of(context).pop();
              },
              isLoading: false,
              btnColor: AppColors.lightGrayBorder,
              titleColor: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
}

