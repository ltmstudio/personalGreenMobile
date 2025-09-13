import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class PerformerWidget extends StatefulWidget {
  const PerformerWidget({super.key, required this.onSelectItem, required this.isSelected});

  final ValueChanged<String> onSelectItem;
  final bool isSelected;

  @override
  State<PerformerWidget> createState() => _PerformerWidgetState();
}

class _PerformerWidgetState extends State<PerformerWidget> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  final performers = [
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
    'Ivan Ivanovich',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectPerformer),
          HomePageSearchWidget(
              hint: 'Введите ФИО или должность сотрудника',
              searchCtrl: _searchCtrl, onSearch: () {}),
          SizedBox(height: 10),

          Expanded(
            child: ListView.separated(
              itemCount: performers.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    widget.onSelectItem(performers[index]);
                    if(widget.isSelected){
                      Navigator.of(context).pop();
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          performers[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Сантехник',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
