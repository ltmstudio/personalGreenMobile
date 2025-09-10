import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class ChecklistWidget extends StatefulWidget {
  const ChecklistWidget({super.key});

  @override
  State<ChecklistWidget> createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  final List<String> tasks = [
    "Проверить электрощитовую",
    "Замерить напряжение в сети",
    "Проверить автоматические выключатели и предохранители",
    "Сообщить в электроснабжающую организацию при необходимости",
  ];

  // Track checked states
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.generate(
      tasks.length,
      (index) => index < 2,
    ); // first 2 checked
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Number
            Text(
              "${index + 1}. ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Expanded text + checkbox
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      tasks[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Checkbox(

                    value: checked[index],
                    onChanged: (val) {
                      setState(() {
                        checked[index] = val ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: AppColors.timeColor,
                    checkColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
