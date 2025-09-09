import 'package:flutter/material.dart';
import 'package:hub_dom/common/widgets/appbar_icon.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/src/presentation/widgets/cards/status_item_card.dart';
import 'package:hub_dom/src/presentation/widgets/chip_widget.dart';

class ApplicationStatusPage extends StatefulWidget {
  const ApplicationStatusPage({super.key});

  @override
  State<ApplicationStatusPage> createState() => _ApplicationStatusPageState();
}

class _ApplicationStatusPageState extends State<ApplicationStatusPage> {

  final statuses = [
    'Все',
    'В работе',
    'Просрочена',
    'Контроль',
    'Контроль',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.applications),
        actions: [
          AppBarIcon(icon: IconAssets.scanner, onTap: () {}),
          AppBarIcon(icon: IconAssets.filter, onTap: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: AppBarIcon(icon: IconAssets.search, onTap: () {}),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 8),
        child: FloatingActionButton(
          backgroundColor: AppColors.green,
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  scrollDirection: Axis.horizontal,
                  itemCount: statuses.length,
                  itemBuilder: (context, index){
                return ChipWidget(title: statuses[index]);
              },
              separatorBuilder: (context, index)=>SizedBox(width: 5,)
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Всего заявок",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ChipWidget(title: '21'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),

            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
          ],
        ),
      ),
    );
  }
}
