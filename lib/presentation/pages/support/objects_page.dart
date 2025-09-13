import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/pages/support/widgets/object_card_item.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({super.key});

  @override
  State<ObjectsPage> createState() => _ObjectsPageState();
}

class _ObjectsPageState extends State<ObjectsPage> {
  final items = [
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
    'ЖК Тестовый',
  ];

  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Объекты')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: HomePageSearchWidget(
              searchCtrl: searchCtrl,
              onSearch: () {},
              hint: 'Поиск',
              filled: true,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ObjectItemWidget(
                  title: '${items[index]} $index',
                  icon: IconAssets.location,
                  color: AppColors.whiteG,
                  subTitle: 'г. Воронеж, ул. Волгоградская, д. 101',
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 12),
            ),
          ),
        ],
      ),
    );
  }
}
