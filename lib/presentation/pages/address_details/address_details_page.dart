import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/pages/performer_details/components/filter_performer_widget.dart';
import 'package:hub_dom/presentation/widgets/appbar_icon.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/status_item_card.dart';
import 'package:hub_dom/presentation/widgets/chip_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';


class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key, required this.title});

  final String title;

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  bool isSearching = false;
  final TextEditingController searchCtrl = TextEditingController();

  final statuses = ['Все', 'В работе', 'Просрочена', 'Контроль', 'Контроль'];

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
              "Отменить",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ]
            : [
          AppBarIcon(icon: IconAssets.scanner, onTap: () {}),
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
          onPressed: () {},
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
                itemCount: statuses.length,
                itemBuilder: (context, index) {
                  return ChipWidget(
                    title: statuses[index],
                    isSelected: index == 0,
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
                    "Всего заявок",
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
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),

            Align(
              alignment: Alignment.center,
              child: ChipWidget(title: '09.09.2025'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StatusItemCard(),
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
      child: FilterPerformerWidget(),
    );
  }
}
