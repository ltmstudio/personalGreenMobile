import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/select_item_widget.dart';

class UrgencyCategoryWidget extends StatefulWidget {
  const UrgencyCategoryWidget({super.key, required this.onSelectItem, required this.isSelected});
  final ValueChanged<String> onSelectItem;
  final bool isSelected;

  @override
  State<UrgencyCategoryWidget> createState() => _UrgencyCategoryWidgetState();
}

class _UrgencyCategoryWidgetState extends State<UrgencyCategoryWidget> {


  @override
  void dispose() {
    super.dispose();
  }

  final types = [
    'Низкая срочность',
    'Средняя срочность',
    'Срочная',
    '⚠️ Аварийная'

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.categoryType),
          SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: types.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index){
                return  SelectItemWidget(
                  index: index,
                  services: types,
                  onSelectItem: (String value) {
                    widget.onSelectItem(value);
                  },
                  isSelected: widget.isSelected,
                );
              },
              separatorBuilder: (context, index)=>Divider(),
            ),
          )

        ],
      ),
    );
  }
}
