import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'widgets/support_item_widget.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final items = [
    'Бухгалтерия',
    'Приемная',
    'Лифтовая служба',
    'Бухгалтерия',
    'Лифтер',
    'Слесарь',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Контакты')),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return SupportItemWidget(
            title: items[index],
            icon: IconAssets.call,
            color: AppColors.green,
            subTitle: '4223-12-12',
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 12),
      ),
    );
  }
}
