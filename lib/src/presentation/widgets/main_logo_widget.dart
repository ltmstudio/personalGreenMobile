import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';

class MainLogoWidget extends StatelessWidget {
  const MainLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            ImageAssets.splashLogo,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10),
        Text(AppStrings.appName,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 30,color: AppColors.darkBlue),),
        SizedBox(height: 5),
        Text('Персонал',style: Theme.of(context).textTheme.titleLarge,),

      ],
    );
  }
}
