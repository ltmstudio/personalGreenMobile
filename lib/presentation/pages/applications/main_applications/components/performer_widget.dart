import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/presentation/bloc/employees/employees_bloc.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class PerformerWidget extends StatefulWidget {
  const PerformerWidget({
    super.key,
    required this.onSelectItem,
    required this.isSelected,
    this.onSelectEmployee,
  });

  final ValueChanged<String> onSelectItem;
  final ValueChanged<Employee>? onSelectEmployee;
  final bool isSelected;

  @override
  State<PerformerWidget> createState() => _PerformerWidgetState();
}

class _PerformerWidgetState extends State<PerformerWidget> {
  final TextEditingController _searchCtrl = TextEditingController();
  String? _searchQuery;
  late EmployeesBloc _employeesBloc;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!mounted) return;
    final query = _searchCtrl.text.trim();
    if (query != _searchQuery) {
      _searchQuery = query;
      if (query.isEmpty) {
        _employeesBloc.add(
          const LoadEmployeesEvent(page: 1, perPage: 10),
        );
      } else if (query.length >= 2) {
        // Отправляем поиск только если запрос содержит минимум 2 символа
        _employeesBloc.add(
          SearchEmployeesEvent(
            fullName: query,
            page: 1,
            perPage: 10,
          ),
        );
      }
      // Если запрос меньше 2 символов, не отправляем запрос
      // (можно показать подсказку, но обычно это не нужно)
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GetIt.instance<EmployeesBloc>();
        _employeesBloc = bloc;
        bloc.add(const LoadEmployeesEvent(page: 1, perPage: 10));
        return bloc;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            BottomSheetTitle(title: AppStrings.selectPerformer),
            HomePageSearchWidget(
              hint: AppStrings.searchHintEmployee,
              searchCtrl: _searchCtrl,
              onSearch: () {},
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.gray),
                    );
                  }

                  if (state is EmployeesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ошибка: ${state.message}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<EmployeesBloc>().add(
                                    const LoadEmployeesEvent(page: 1, perPage: 10),
                                  );
                            },
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is EmployeesLoaded) {
                    final employees = state.employees;

                    if (employees.isEmpty) {
                      return Center(
                        child: Text(
                          'Исполнители не найдены',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: employees.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        final displayName =
                            employee.fullName ?? 'Данных нет';
                        final position = employee.position ?? 'Данных нет';

                        return InkWell(
                          onTap: () {
                            widget.onSelectItem(displayName);
                            widget.onSelectEmployee?.call(employee);
                            if (widget.isSelected) {
                              Navigator.of(context).pop();
                            }
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  position,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
