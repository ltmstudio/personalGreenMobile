import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/performer_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/buttons/selectable_btn.dart';

import 'components/create_performer_widget.dart';
import 'components/employee_app.dart';
import 'components/employee_report.dart';

class EmployeeAppDetailsPage extends StatefulWidget {
  const EmployeeAppDetailsPage({super.key, required this.title});

  final String title;

  @override
  State<EmployeeAppDetailsPage> createState() => _EmployeeAppDetailsPageState();
}

class _EmployeeAppDetailsPageState extends State<EmployeeAppDetailsPage> {
  final statuses = ['Все', 'В работе', 'Просрочена', 'Контроль', 'Контроль'];
  int index = 0;




  Future<void> _handleBack() async {
    // Use the context of the page, not the bottom sheet
    final shouldPop = await showConfirmBack(context);
    if (shouldPop) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          actions: [
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Контроль",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.check_circle_outline_sharp, size: 18),
                  ],
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableBtn(
                    isSelected: index == 0,
                    title: "Заявка",
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  SelectableBtn(
                    isSelected: index == 1,
                    title: "Отчет",
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        body: index == 0
            ? EmployeeAppsPage()
            : EmployeeReportPage(),
      ),
    );
  }

}
