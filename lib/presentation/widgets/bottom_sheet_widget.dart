import 'package:flutter/material.dart';

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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
        Row(
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
