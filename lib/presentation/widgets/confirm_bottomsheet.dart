import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';

import 'buttons/main_btn.dart';
import 'bottom_sheet_widget.dart';

class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
            buttonTile: AppStrings.confirm,
            onPressed: () {},
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
