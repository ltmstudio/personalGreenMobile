import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
import 'package:hub_dom/presentation/pages/support/widgets/object_card_item.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class ObjectsPage extends StatefulWidget {
  const ObjectsPage({super.key});

  @override
  State<ObjectsPage> createState() => _ObjectsPageState();
}

class _ObjectsPageState extends State<ObjectsPage> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddressesBloc>().add(const LoadAddressesEvent());
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.objects)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: HomePageSearchWidget(
              searchCtrl: searchCtrl,
              onSearch: () => setState(() {}), // фильтр по вводу
              hint: AppStrings.search,
              filled: true,
            ),
          ),

          Expanded(
            child: BlocBuilder<AddressesBloc, AddressesState>(
              builder: (context, state) {
                if (state is AddressesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AddressesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AddressesBloc>().add(
                              const LoadAddressesEvent(),
                            );
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final items = state is AddressesLoaded
                    ? (state.addresses ?? <AddressData>[])
                    : <AddressData>[];

                final q = searchCtrl.text.trim().toLowerCase();
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
                  padding: const EdgeInsets.all(20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];

                    return ObjectItemWidget(
                      // если у тебя есть реальное имя объекта, ставь сюда.
                      // сейчас логично показать тип + id
                      title: item.type?.displayName ?? 'Объект',
                      icon: IconAssets.location,
                      color: AppColors.whiteG,
                      subTitle: item.address ?? '',
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
