import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/select_item_widget.dart';

class WorkTypeWidget extends StatefulWidget {
  const WorkTypeWidget({super.key, required this.onSelectItem});

  final ValueChanged<String> onSelectItem;

  @override
  State<WorkTypeWidget> createState() => _WorkTypeWidgetState();
}

class _WorkTypeWidgetState extends State<WorkTypeWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  final types = ['Обратная тяга', 'Не работает вентиляция', 'Прочее'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectWorkType),
          SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: types.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return SelectItemWidget(
                  index: index,
                  services: types,
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
