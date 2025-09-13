import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/cards/employee_card.dart';
import 'package:hub_dom/presentation/widgets/cards/object_card.dart';
import 'package:hub_dom/presentation/widgets/cards/stat_card.dart';
import 'package:hub_dom/presentation/widgets/filter_widget.dart';

import 'components/address_widget.dart';
import 'components/performer_widget.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  DateTimeRange<DateTime>? selectedDate;
  String? selectedAddress;
  String? selectedPerformer;

  @override
  void initState() {
    super.initState();
    clear();
  }

  clear() {
    selectedAddress = null;
    selectedPerformer = null;
    selectedDate = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.applications),
        actions: [
          AppBarIcon(icon: IconAssets.scanner, onTap: () {
            context.push(AppRoutes.scanner);
          }),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: AppBarIcon(icon: IconAssets.filter, onTap: _showFilter),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 8),
        child: FloatingActionButton(
          backgroundColor: AppColors.green,
          onPressed: () {
            context.push(AppRoutes.createApplication);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Все заявки", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),

            SizedBox(
              height: 165,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pie Chart
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push('${AppRoutes.appCategory}/Все');
                      },
                      child: MainCardWidget(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Все 142',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 110,
                              width: 110,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: AppColors.lightRed,
                                      value: 18,
                                      title: '',
                                      radius: 20,
                                    ),
                                    PieChartSectionData(
                                      color: AppColors.lightBlue,
                                      value: 12,
                                      title: '',
                                      radius: 20,
                                    ),
                                    PieChartSectionData(
                                      color: AppColors.yellow,
                                      value: 17,
                                      title: '',
                                      radius: 20,
                                    ),
                                    PieChartSectionData(
                                      color: AppColors.lightGreen,
                                      value: 5,
                                      title: '',
                                      radius: 20,
                                    ),
                                  ],
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          title: "В работе",
                          value: "18",
                          percent: "28%",
                          color: Colors.blue,
                        ),
                        StatCard(
                          title: "Просрочено",
                          value: "112",
                          percent: "30%",
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: StatCard(
                      title: "Контроль",
                      value: "17",
                      percent: "40%",
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: StatCard(
                      title: "Выполнена",
                      value: "5",
                      percent: "14%",
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            ExpansionTile(
              title: Text(
                "Сотрудники (42)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              initiallyExpanded: true,
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              // optional
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              children: [
                SelectBtn(
                  title: 'Выберите сотрудника',
                  //value: selectedPerformer,
                  showBorder: false,
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGrayBorder,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                  onTap: _showPerformer,
                ),
                EmployeeCard(
                  name: "Иванов Иван Иванович",
                  role: "Сантехник",
                  ratio: "12/30",
                ),
                EmployeeCard(
                  name: "Иванов Иван Иванович",
                  role: "Сантехник",
                  ratio: "12/30",
                ),
                EmployeeCard(
                  name: "Иванов Иван Иванович",
                  role: "Сантехник",
                  ratio: "12/30",
                ),
              ],
            ),

            const SizedBox(height: 12),

            ExpansionTile(
              title: Text(
                "Объекты (42)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              initiallyExpanded: true,
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              // optional
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              children: [
                SelectBtn(
                  title: 'Выберите объект',
                  showBorder: false,
               //   value: selectedAddress,
                  icon: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGrayBorder,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                  onTap: _showObject,
                ),
                ObjectCard(
                  address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                  stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                ),
                ObjectCard(
                  address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                  stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                ),
                ObjectCard(
                  address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                  stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                ),
                ObjectCard(
                  address: "г. Воронеж, ЖК «Тестовый», ул. Краснознам...",
                  stats: {"blue": 12, "red": 12, "green": 6, "orange": 1},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: FilterApplicationsWidget(),
    );
  }

  _showPerformer() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(
        onSelectItem: (String value) {
          // setState(() {
          selectedPerformer = value;
          // });
          context.push('${AppRoutes.performerDetails}/$selectedPerformer');
        },
        isSelected: false,
      ),
    );
  }

  _showObject() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: AddressWidget(
        onSelectItem: (String value) {
          // setState(() {
          selectedAddress = value;
          // });
          context.push('${AppRoutes.addressDetails}/$selectedAddress');
        },
        isSelected: false,
      ),
    );
  }
}
