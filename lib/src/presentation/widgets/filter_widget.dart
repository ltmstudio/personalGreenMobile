import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/common/widgets/main_btn.dart';
import 'package:hub_dom/common/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/src/presentation/widgets/bottom_sheet_widget.dart';

import 'date_widgets/date_range_widget.dart';
import 'date_widgets/date_widget.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
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
