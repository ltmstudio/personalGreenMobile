import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/cards/select_item_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

//todo address search
class AddressWidget extends StatefulWidget {
  const AddressWidget({
    super.key,
    required this.onSelectItem,
    required this.isSelected,
  });

  final ValueChanged<String> onSelectItem;
  final bool isSelected;

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

          HomePageSearchWidget(
            searchCtrl: _searchCtrl,
            onSearch: () => setState(() {}), // фильтр по тексту
          ),

          const SizedBox(height: 10),

          Expanded(
            child: BlocBuilder<AddressesBloc, AddressesState>(
              builder: (context, state) {
                if (state is AddressesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AddressesError) {
                  return Center(child: Text(state.message));
                }

                final items = state is AddressesLoaded
                    ? (state.addresses.data ?? <AddressData>[])
                    : <AddressData>[];

                // простой поиск
                final q = _searchCtrl.text.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? items
                    : items.where((a) {
                  final addr = (a.address ?? '').toLowerCase();
                  return addr.contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Ничего не найдено'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final addr = item.address ?? '';

                    return SelectItemWidget(
                      index: index,
                      services: filtered.map((e) => e.address ?? '').toList(),
                      onSelectItem: (_) => widget.onSelectItem(addr),
                      isSelected: widget.isSelected,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



// class AddressWidget extends StatefulWidget {
//   const AddressWidget({
//     super.key,
//     required this.onSelectItem,
//     required this.isSelected,
//   });
//
//   final ValueChanged<String> onSelectItem;
//   final bool isSelected;
//
//   @override
//   State<AddressWidget> createState() => _AddressWidgetState();
// }
//
// class _AddressWidgetState extends State<AddressWidget> {
//   final TextEditingController _searchCtrl = TextEditingController();
//
//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }
//
//   final addresses = [
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//     'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           BottomSheetTitle(title: AppStrings.selectAddress),
//           HomePageSearchWidget(searchCtrl: _searchCtrl, onSearch: () {}),
//           SizedBox(height: 10),
//
//           Expanded(
//             child: ListView.separated(
//               itemCount: addresses.length,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return SelectItemWidget(
//                   index: index,
//                   services: addresses,
//                   onSelectItem: (String value) {
//                     widget.onSelectItem(value);
//                   },
//                   isSelected: widget.isSelected,
//                 );
//               },
//               separatorBuilder: (context, index) => Divider(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
