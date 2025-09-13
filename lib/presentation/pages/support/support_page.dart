import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';

import 'widgets/support_item_widget.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Поддержка')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                context.push(AppRoutes.objects);
              },
              child: SupportItemWidget(
                title: 'Объекты',
                icon: IconAssets.house,
                color: AppColors.timeColor,
              ),
            ),

            SizedBox(height: 12),
            GestureDetector(
              onTap: (){
                context.push(AppRoutes.contacts);
              },
              child: SupportItemWidget(
                title: 'Контакты УК',
                icon: IconAssets.call,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
