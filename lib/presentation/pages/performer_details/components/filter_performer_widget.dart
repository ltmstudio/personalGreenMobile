import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/date_widgets/date_range_widget.dart';

class FilterPerformerWidget extends StatefulWidget {
  final DateTimeRange? initialDate;
  final ServiceType? initialServiceType;
  final TroubleType? initialTroubleType;
  final Type? initialPriorityType;
  final Function(DateTimeRange?, ServiceType?, TroubleType?, Type?)?
  onFiltersApplied;

  const FilterPerformerWidget({
    super.key,
    this.initialDate,
    this.initialServiceType,
    this.initialTroubleType,
    this.initialPriorityType,
    this.onFiltersApplied,
  });

  @override
  State<FilterPerformerWidget> createState() => _FilterPerformerWidgetState();
}

class _FilterPerformerWidgetState extends State<FilterPerformerWidget> {
  DateTimeRange? selectedDate;
  ServiceType? selectedServiceType;
  TroubleType? selectedTroubleType;
  Type? selectedPriorityType;
  DictionariesBloc? _dictionariesBloc;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedServiceType = widget.initialServiceType;
    selectedTroubleType = widget.initialTroubleType;
    selectedPriorityType = widget.initialPriorityType;
  }

  clear() {
    setState(() {
      selectedServiceType = null;
      selectedTroubleType = null;
      selectedPriorityType = null;
      selectedDate = null;
    });
    // Применяем очистку фильтров
    widget.onFiltersApplied?.call(null, null, null, null);
  }

  bool _hasAnyFilterSelected() {
    return selectedDate != null ||
        selectedServiceType != null ||
        selectedTroubleType != null ||
        selectedPriorityType != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _dictionariesBloc = locator<DictionariesBloc>()
          ..add(const LoadDictionariesEvent());
        return _dictionariesBloc!;
      },
      child: BlocBuilder<DictionariesBloc, DictionariesState>(
        builder: (context, state) {
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
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            initialDateRange: selectedDate,
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
                            value: selectedServiceType?.title,
                            onClear: () {
                              setState(() {
                                selectedServiceType = null;
                                selectedTroubleType = null;
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
                            value: selectedTroubleType?.title,
                            onClear: () {
                              setState(() {
                                selectedTroubleType = null;
                              });
                            },
                            onTap: selectedServiceType != null
                                ? _showWorkType
                                : null,
                            isDisabled: selectedServiceType == null,
                          ),
                        ),

                        SizedBox(height: 12),
                        TextFieldTitle(
                          title: AppStrings.categoryType,
                          child: selectBtnWidget(
                            title: AppStrings.selectCategoryType,
                            value: selectedPriorityType?.title,
                            onClear: () {
                              setState(() {
                                selectedPriorityType = null;
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
                  onPressed: _applyFilters,
                  isLoading: false,
                  isDisable: !_hasAnyFilterSelected(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SelectBtn selectBtnWidget({
    required String title,
    required String? value,
    required VoidCallback? onTap,
    required VoidCallback onClear,
    bool isDisabled = false,
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
      onTap: isDisabled ? () {} : (onTap ?? () {}),
    );
  }

  _showService() {
    if (_dictionariesBloc == null) return;
    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      final serviceTypes = state.dictionaries.serviceTypes ?? [];

      bottomSheetWidget(
        context: context,
        isScrollControlled: true,
        child: _ServiceTypesSelectionWidget(
          serviceTypes: serviceTypes,
          selectedServiceType: selectedServiceType,
          onSelect: (serviceType) {
            setState(() {
              selectedServiceType = serviceType;
              selectedTroubleType = null;
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  _showWorkType() {
    if (selectedServiceType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Сначала выберите услугу')));
      return;
    }
    if (_dictionariesBloc == null) return;

    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      var troubleTypes = selectedServiceType!.troubleTypes ?? [];

      if (troubleTypes.isEmpty) {
        final allTroubleTypes = state.dictionaries.troubleTypes ?? [];
        troubleTypes = allTroubleTypes
            .where((tt) => tt.serviceTypeId == selectedServiceType!.id)
            .toList();
      }

      if (troubleTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Для выбранной услуги нет доступных типов работ'),
          ),
        );
        return;
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _TroubleTypesSelectionWidget(
          troubleTypes: troubleTypes,
          selectedTroubleType: selectedTroubleType,
          onSelect: (troubleType) {
            setState(() {
              selectedTroubleType = troubleType;
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  _showUrgency() {
    if (_dictionariesBloc == null) return;
    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      final priorityTypes = state.dictionaries.priorityTypes ?? [];

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _PriorityTypesSelectionWidget(
          priorityTypes: priorityTypes,
          selectedPriorityType: selectedPriorityType,
          onSelect: (priorityType) {
            setState(() {
              selectedPriorityType = priorityType;
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  void _applyFilters() {
    // Вызываем callback для сохранения состояния фильтров
    // Загрузка заявок будет Выполнено в родительском виджете
    widget.onFiltersApplied?.call(
      selectedDate,
      selectedServiceType,
      selectedTroubleType,
      selectedPriorityType,
    );
    // Не закрываем здесь, закрытие будет в родительском виджете
  }
}

// Виджет выбора типов услуг
class _ServiceTypesSelectionWidget extends StatelessWidget {
  final List<ServiceType> serviceTypes;
  final ServiceType? selectedServiceType;
  final Function(ServiceType) onSelect;

  const _ServiceTypesSelectionWidget({
    required this.serviceTypes,
    required this.selectedServiceType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(
            title: AppStrings.selectService,
            onClear: serviceTypes.isNotEmpty
                ? () => onSelect(serviceTypes.first)
                : null,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: serviceTypes.length,
              itemBuilder: (context, index) {
                final serviceType = serviceTypes[index];
                final isSelected = selectedServiceType?.id == serviceType.id;

                return ListTile(
                  title: Text(serviceType.title ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onSelect(serviceType);
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Виджет выбора типов проблем
class _TroubleTypesSelectionWidget extends StatelessWidget {
  final List<TroubleType> troubleTypes;
  final TroubleType? selectedTroubleType;
  final Function(TroubleType) onSelect;

  const _TroubleTypesSelectionWidget({
    required this.troubleTypes,
    required this.selectedTroubleType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(
            title: AppStrings.selectWorkType,
            onClear: troubleTypes.isNotEmpty
                ? () => onSelect(troubleTypes.first)
                : null,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: troubleTypes.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Нет доступных типов работ'),
                    ),
                  )
                : ListView.builder(
                    itemCount: troubleTypes.length,
                    itemBuilder: (context, index) {
                      final troubleType = troubleTypes[index];
                      final isSelected =
                          selectedTroubleType?.id == troubleType.id;

                      return ListTile(
                        title: Text(troubleType.title ?? ''),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onSelect(troubleType);
                          context.pop();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Виджет выбора типов приоритета
class _PriorityTypesSelectionWidget extends StatelessWidget {
  final List<Type> priorityTypes;
  final Type? selectedPriorityType;
  final Function(Type) onSelect;

  const _PriorityTypesSelectionWidget({
    required this.priorityTypes,
    required this.selectedPriorityType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(
            title: AppStrings.selectCategoryType,
            onClear: priorityTypes.isNotEmpty
                ? () => onSelect(priorityTypes.first)
                : null,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: priorityTypes.length,
              itemBuilder: (context, index) {
                final priorityType = priorityTypes[index];
                final isSelected = selectedPriorityType?.id == priorityType.id;

                return ListTile(
                  title: Text(priorityType.title ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onSelect(priorityType);
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
