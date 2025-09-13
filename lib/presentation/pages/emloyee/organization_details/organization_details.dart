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
import 'components/filter_organization_widget.dart';


class OrganizationDetailsPage extends StatefulWidget {
  const OrganizationDetailsPage({super.key, required this.title});

  final String title;

  @override
  State<OrganizationDetailsPage> createState() => _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  final statuses = AppStrings.statuses;
  int selectedCategory = 0;

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
          AppBarIcon(icon: IconAssets.scanner, onTap: () {
            context.push(AppRoutes.scanner);

          }),
          AppBarIcon(icon: IconAssets.filter, onTap: _showFilter),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
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
            context.push(AppRoutes.createEmployeeApp);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title.contains('Все'))
              SizedBox(
                height: 50,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  scrollDirection: Axis.horizontal,
                  itemCount: statuses.length,
                  itemBuilder: (context, index) {
                    return ChipWidget(
                      title: statuses[index],
                      isSelected: index == selectedCategory,
                      onTap: (){
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
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),

            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppItemCard(isManager: false,),
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
      child: FilterOrganizationWidget(),
    );
  }
}
