import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/pages/aplications/components/services_widget.dart';
import 'package:hub_dom/presentation/pages/aplications/components/urgency_category_widget.dart';
import 'package:hub_dom/presentation/pages/aplications/components/work_type_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/date_widgets/date_range_widget.dart';

class FilterPerformerWidget extends StatefulWidget {
  const FilterPerformerWidget({super.key});

  @override
  State<FilterPerformerWidget> createState() => _FilterPerformerWidgetState();
}

class _FilterPerformerWidgetState extends State<FilterPerformerWidget> {
  DateTimeRange<DateTime>? selectedDate;
  String? selectedService;
  String? selectedWorkType;
  String? selectedUrgency;

  @override
  void initState() {
    super.initState();
    clear();
  }
  clear(){
    selectedService = null;
    selectedWorkType = null;
    selectedUrgency = null;
    selectedDate = null;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.filter, onClear: clear),
          SizedBox(height: 20),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  SizedBox(height: 12),

                  TextFieldTitle(
                    title: AppStrings.service,
                    child: selectBtnWidget(
                      title: AppStrings.selectService,
                      value: selectedService,
                      onClear: () {
                        setState(() {
                          selectedService = null;
                        });
                      },
                      onTap: _showService,
                    ),
                  ),
                  SizedBox(height: 12),

                  TextFieldTitle(
                    title: AppStrings.workType,
                    child: selectBtnWidget(
                      title: AppStrings.selectWorkType,
                      value: selectedWorkType,
                      onClear: () {
                        setState(() {
                          selectedWorkType = null;
                        });
                      },
                      onTap: _showWorkType,
                    ),
                  ),

                  SizedBox(height: 12),
                  TextFieldTitle(
                    title: AppStrings.categoryType,
                    child: selectBtnWidget(
                      title: AppStrings.selectCategoryType,
                      value: selectedUrgency,
                      onClear: () {
                        setState(() {
                          selectedUrgency = null;
                        });
                      },
                      onTap: _showUrgency,
                    ),
                  ),
                ],
              ),
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

  SelectBtn selectBtnWidget({
    required String title,
    required String? value,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return SelectBtn(
      title: title,
      value: value,
      showBorder: true,

      color: Colors.transparent,
      icon: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onClear,
        child: Icon(value == null ? Icons.keyboard_arrow_down : Icons.cancel),
      ),
      onTap: onTap,
    );
  }

  _showService() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: ServicesWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedService = value;
          });
        },
      ),
    );
  }

  _showWorkType() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: WorkTypeWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedWorkType = value;
          });
        },
      ),
    );
  }

  _showUrgency() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: UrgencyCategoryWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedUrgency = value;
          });
        },
      ),
    );
  }

}
