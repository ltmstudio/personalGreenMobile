import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/src/presentation/widgets/bottom_sheet_widget.dart';

class ServicesWidget extends StatefulWidget {
  const ServicesWidget({super.key});

  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {


  @override
  void dispose() {
    super.dispose();
  }

  final services = [
    'Электрика',
    'Сантехника',
    'Вентиляция',
    'Отопление',
    'Водоснабжение  ',
    'Домофония ',
    'ИПУ',
    'Обслуживание подъездов',
    'Обслуживание территории',
    'Акты',
    'Прочее',

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectService),
          SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: services.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index){
                return Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(services[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
