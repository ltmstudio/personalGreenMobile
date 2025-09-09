import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/src/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/src/presentation/widgets/search_widgets/search_widget.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectAddress),
          HomePageSearchWidget(searchCtrl:_searchCtrl, onSearch: (){},),
         SizedBox(height: 10),

          Expanded(
            child: ListView.separated(
                itemCount: 20,
                shrinkWrap: true,
                itemBuilder: (context, index){
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
                child: Text('г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            separatorBuilder: (context, index)=>Divider(),
            ),
          )

        ],
      ),
    );
  }
}
