import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final items = [
    'УК «Название 1»',
    'УК «Название 2»',
    'УК «Название 3»',
    'УК «Название 4»',
    'УК «Название 5»',
    'УК «Название 6»',
    'УК «Название 7»',
    'УК «Название 8»',
    'УК «Название 9»',
    'УК «Название 10»',
    'УК «Название 11»',
    'УК «Название 12»',
    'УК «Название 13»',
    'УК «Название 14»',
    'УК «Название 15»',
    'УК «Название 16»',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Организации')),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              context.push('${AppRoutes.organizationDetails}/${items[index]}');
            },
            child: MainCardWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[index],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.timeColor,
                    ),
                    child: SvgPicture.asset(IconAssets.house),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemCount: items.length,
      ),
    );
  }
}
