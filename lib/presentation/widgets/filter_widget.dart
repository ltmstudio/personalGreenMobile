import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';

import 'bottom_sheet_widget.dart';
import 'date_widgets/date_range_widget.dart';

class FilterApplicationsWidget extends StatefulWidget {
  final TicketsBloc ticketsBloc;
  final DateTimeRange<DateTime>? initialDate;
  final Function(DateTimeRange<DateTime>?)? onFiltersApplied;

  const FilterApplicationsWidget({
    super.key,
    required this.ticketsBloc,
    this.initialDate,
    this.onFiltersApplied,
  });

  @override
  State<FilterApplicationsWidget> createState() =>
      _FilterApplicationsWidgetState();
}

class _FilterApplicationsWidgetState extends State<FilterApplicationsWidget> {
  DateTimeRange<DateTime>? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  void _applyFilters() {
    // Вызываем callback для сохранения состояния фильтров
    // Загрузка заявок будет выполнена в родительском виджете
    widget.onFiltersApplied?.call(selectedDate);

    context.pop();
  }

  void _clearFilters() {
    setState(() {
      selectedDate = null;
    });
    // Сбрасываем фильтр
    widget.ticketsBloc.add(const LoadTicketsEvent(page: 1, perPage: 1000));
    widget.onFiltersApplied?.call(null);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTitle(
            title: AppStrings.filter,
            onClear: selectedDate != null ? _clearFilters : null,
          ),
          SizedBox(height: 20),

          TextFieldTitle(
            title: AppStrings.period,
            child: SelectDateRangeWidget(
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: selectedDate,
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
            onPressed: _applyFilters,
            isLoading: false,
            isDisable: selectedDate == null,
          ),
        ],
      ),
    );
  }
}
