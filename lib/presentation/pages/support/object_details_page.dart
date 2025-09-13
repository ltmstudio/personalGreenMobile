import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/pages/support/widgets/support_item_widget.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

class ObjectDetailsPage extends StatefulWidget {
  const ObjectDetailsPage({super.key});

  @override
  State<ObjectDetailsPage> createState() => _ObjectDetailsPageState();
}

class _ObjectDetailsPageState extends State<ObjectDetailsPage> {
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
      appBar: AppBar(title: Text('Информация об объекте')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Данные',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  SizedBox(height: 12),
                  MainCardWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldTitle(
                          title: 'Адрес',
                          child: Text(
                            'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),

                        TextFieldTitle(
                          title: 'Подъездов',
                          child: Text(
                            '5',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),

                        TextFieldTitle(
                          title: 'Этажей',
                          child: Text(
                            '12',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),

                        TextFieldTitle(
                          title: 'Квартир',
                          child: Text(
                            '160',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),

                        TextFieldTitle(
                          title:
                              'Ключи от подвала находятся в диспетчерской УК',
                          child: Text(
                            '160',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),

                        TextFieldTitle(
                          title: 'Комментарий',
                          child: Text(
                            'Нумерация подъездов начинается с правой стороны',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Контакты',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  // Text(
                  //   'Нет контактов по адресу',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SupportItemWidget(
                      title: items[index],
                      icon: IconAssets.call,
                      color: AppColors.green,
                      subTitle: '4223-12-12',
                    ),
                  );
                },
                childCount: items.length, // total number of items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
