import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/app_item_card.dart';
import 'package:hub_dom/presentation/widgets/chip_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';

import 'components/filter_address_widget.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key, required this.title});

  final String title;

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  int selectedCategory = 0;

  // Стандартные статусы из API
  List<StatusModel> get standardStatuses {
    return [
      StatusModel(name: 'in_progress', title: 'В работе', color: '#87CFF8'),
      StatusModel(name: 'done', title: 'Выполнена', color: '#93CD64'),
      StatusModel(name: 'approval', title: 'Согласование', color: '#EB7B36'),
      StatusModel(name: 'control', title: 'Контроль', color: '#F1D675'),
    ];
  }

  List<String> get statusTitles {
    return ['Все', ...standardStatuses.map((s) => s.title ?? '').toList()];
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? HomePageSearchWidget(searchCtrl: searchCtrl, onSearch: () {})
            : Text(widget.title),
        actions: isSearching
            ? [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchCtrl.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  child: Text(
                    AppStrings.cancelIt,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.scanner,
                    onTap: () {
                      context.push(AppRoutes.scanner);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.filter,
                    onTap: _showFilter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10),
                  child: AppBarIcon(
                    icon: IconAssets.search,
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
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
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),

                scrollDirection: Axis.horizontal,
                itemCount: statusTitles.length,
                itemBuilder: (context, index) {
                  return ChipWidget(
                    title: statusTitles[index],
                    isSelected: index == selectedCategory,
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 5),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.allApps,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ChipWidget(title: '21'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),

            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: true),
            ),
          ],
        ),
      ),
    );
  }

  _showFilter() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: FilterAddressWidget(),
    );
  }
}
