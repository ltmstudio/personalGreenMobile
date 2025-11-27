import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

/// Серый индикатор загрузки для использования по всему приложению
class GrayLoadingIndicator extends StatelessWidget {
  final double? size;
  final double strokeWidth;

  const GrayLoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      color: AppColors.gray,
      strokeWidth: strokeWidth,
    );

    if (size != null) {
      return SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return indicator;
  }
}




