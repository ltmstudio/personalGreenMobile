import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(IconAssets.error),
        SizedBox(height: 10),
        Text(
          AppStrings.error,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.gray),
        ),
        SizedBox(height: 6),
        Text(
          AppStrings.hasError,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
        ),
        SizedBox(height: 20),

        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7,horizontal: 40),
            decoration: BoxDecoration(color: Color(0xffE2E5E9),
            borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppStrings.repeat,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
            ),
          ),
        ),
      ],
    );
  }


}
