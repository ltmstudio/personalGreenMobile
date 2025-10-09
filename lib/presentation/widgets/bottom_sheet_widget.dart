import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

import 'buttons/main_btn.dart';

bottomSheetWidget({
  required BuildContext context,
  required bool isScrollControlled,
  required Widget child,
  Color? color,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: isScrollControlled,
    context: context,
    backgroundColor:
        color ?? Theme.of(context).bottomSheetTheme.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (ctx) => child,
  );
}

Future<bool> showConfirmBack(BuildContext context) async {
  // Create a local context for the bottom sheet
  final shouldPop = await showModalBottomSheet<bool>(
    context: context, // this context is fine
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetTitle(title: 'Закрыть отчет?'),
              const SizedBox(height: 10),
              Text(
                'При выходе со страницы заполненные данные не сохранятся',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              MainButton(
                buttonTile: 'Продолжить',
                onPressed: () {
                  Navigator.of(ctx).pop(false); // close sheet
                },
                isLoading: false,
              ),
              const SizedBox(height: 12),
              MainButton(
                buttonTile: 'Закрыть',
                btnColor: AppColors.closeBtnGray,
                titleColor: AppColors.primary,
                elevation: 1,
                onPressed: () {
                  Navigator.of(ctx).pop(true); // return true to caller
                },
                isLoading: false,
              ),
            ],
          ),
        ),
      );
    },
  );

  return shouldPop ?? false;
}

class BottomSheetTitle extends StatelessWidget {
  const BottomSheetTitle({
    super.key,
    required this.title,
    this.color,
    this.onClear,
  });

  final String title;
  final Color? color;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              TextButton(
                onPressed: onClear,
                child: Text(
                  'Сбросить все',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: color ?? Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
