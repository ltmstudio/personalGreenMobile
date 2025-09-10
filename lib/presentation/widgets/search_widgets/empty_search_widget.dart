import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(IconAssets.emptySearch),
        SizedBox(height: 10),
        Text(
          'Нет результатов',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.gray),
        ),
        SizedBox(height: 6),
        Text(
          '''По вашему запросу ничего не найдено, проверьте правильность введенных данных и повторите попытку''',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
