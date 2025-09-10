import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/select_item_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key, required this.onSelectItem});

  final ValueChanged<String> onSelectItem;

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  final addresses = [
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
    'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectAddress),
          HomePageSearchWidget(searchCtrl: _searchCtrl, onSearch: () {}),
          SizedBox(height: 10),

          Expanded(
            child: ListView.separated(
              itemCount: addresses.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SelectItemWidget(
                  index: index,
                  services: addresses,
                  onSelectItem: (String value) {
                    widget.onSelectItem(value);
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
