import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';

import 'bottom_sheet_widget.dart';
import 'date_widgets/date_range_widget.dart';

class FilterApplicationsWidget extends StatefulWidget {
  const FilterApplicationsWidget({super.key});

  @override
  State<FilterApplicationsWidget> createState() =>
      _FilterApplicationsWidgetState();
}

class _FilterApplicationsWidgetState extends State<FilterApplicationsWidget> {
  DateTimeRange<DateTime>? selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.filter),
          SizedBox(height: 20),

          TextFieldTitle(
            title: AppStrings.period,
            child: SelectDateRangeWidget(
              onDateRangeSelected: (v) {
                setState(() {
                  selectedDate = v;
                });
              },
            ),
          ),
          SizedBox(height: 20),

          MainButton(
            buttonTile: AppStrings.primenit,
            onPressed: () {
              context.pop();
            },
            isLoading: false,
            isDisable: selectedDate == null,
          ),
        ],
      ),
    );
  }
}
