import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/report_page.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/performer_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/selectable_btn.dart';

import 'apps_page.dart';

final String img =
    'https://plus.unsplash.com/premium_photo-1707213919549-deeb789008c0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8NnNNVmpUTFNrZVF8fGVufDB8fHx8fA%3D%3D';

class ApplicationDetailsPage extends StatefulWidget {
  const ApplicationDetailsPage({super.key});

  @override
  State<ApplicationDetailsPage> createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage> {
  final statuses = AppStrings.statuses;
  int index = 0;
  String? selectedPerformer;
  String? selectedContact;

  @override
  void initState() {
    super.initState();
    selectedPerformer = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявка №123'),
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
                    AppStrings.control,
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
                  title: AppStrings.application,
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                ),
                SizedBox(width: 5),
                SelectableBtn(
                  isSelected: index == 1,
                  title: AppStrings.report,
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
          ? AppsPage(
              selectedPerformer: selectedPerformer,
              selectedContact: selectedContact,
              onShowPerformer: _showPerformer,
              onShowContact: _showPerformer,
            )
          : AppDetailsReportPage(),
    );
  }

  _showPerformer() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedPerformer = value;
            selectedContact = value;
          });
        },
        isSelected: true,
      ),
    );
  }
}
