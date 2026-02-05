import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({
    super.key,
    required this.onSelectItem,
    required this.selectedAddress,
  });

  final Function(String address, AddressData data) onSelectItem;
  final String? selectedAddress;

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final currentState = context.read<AddressesBloc>().state;
      if (currentState is AddressesLoaded && currentState.hasMore) {
        context.read<AddressesBloc>().add(
          LoadMoreAddressesEvent(
            search: _searchCtrl.text.trim().isEmpty
                ? null
                : _searchCtrl.text.trim(),
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final searchQuery = query.trim();
      context.read<AddressesBloc>().add(SearchAddressesEvent(searchQuery));
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    context.read<AddressesBloc>().add(const LoadAddressesEvent(page: 1));
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
            onSearch: () => _onSearchChanged(_searchCtrl.text),
            //   onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          const SizedBox(height: 12),

          // Pagination info
          BlocBuilder<AddressesBloc, AddressesState>(
            builder: (context, state) {
              if (state is AddressesLoaded && state.meta != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Показано ${state.addresses.length} из ${state.meta!.total ?? 0}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      if (state.meta!.currentPage != null &&
                          state.meta!.lastPage != null)
                        Text(
                          'Стр. ${state.meta!.currentPage}/${state.meta!.lastPage}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<AddressesBloc, AddressesState>(
              builder: (context, state) {
                // Loading state
                if (state is AddressesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state (without previous data)
                if (state is AddressesError &&
                    state.previousAddresses == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<AddressesBloc>().add(
                              LoadAddressesEvent(
                                search: _searchCtrl.text.trim().isEmpty
                                    ? null
                                    : _searchCtrl.text.trim(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                // Get addresses
                List<AddressData> addresses = [];
                bool isLoadingMore = false;
                bool hasMore = false;
                AddressMeta? meta;

                if (state is AddressesLoaded) {
                  addresses = state.addresses;
                  hasMore = state.hasMore;
                  meta = state.meta;
                } else if (state is AddressesLoadingMore) {
                  addresses = state.currentAddresses;
                  isLoadingMore = true;
                  meta = state.meta;
                }

                // Empty state
                if (addresses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchCtrl.text.trim().isEmpty
                                ? Icons.home_work_outlined
                                : Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchCtrl.text.trim().isEmpty
                                ? 'Нет доступных адресов'
                                : 'Адреса не найдены',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (_searchCtrl.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Попробуйте изменить запрос',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.clear),
                              label: const Text('Очистить поиск'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                // List with items
                return ListView.separated(
                  controller: _scrollController,
                  itemCount:
                      addresses.length + (isLoadingMore || hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator at the end
                    if (index >= addresses.length) {
                      if (isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (hasMore) {
                        return const SizedBox(height: 50);
                      }
                      return const SizedBox.shrink();
                    }

                    final address = addresses[index];
                    final addressText = address.address ?? '';
                    final isSelected = widget.selectedAddress == addressText;

                    return InkWell(
                      onTap: () {
                        widget.onSelectItem(addressText, address);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.05)
                              : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addressText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : null,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (address.type != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            address.type == AddressType.house
                                                ? Icons.home_outlined
                                                : Icons.business_outlined,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            address.type!.displayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Optional: Show statistics
                                  if (address.statistics.inProgress > 0 ||
                                      address.statistics.done > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Wrap(
                                        spacing: 8,
                                        children: [
                                          if (address.statistics.inProgress > 0)
                                            _StatisticChip(
                                              label: 'В работе',
                                              count:
                                                  address.statistics.inProgress,
                                              color: Colors.orange,
                                            ),
                                          if (address.statistics.done > 0)
                                            _StatisticChip(
                                              label: 'Выполнено',
                                              count: address.statistics.done,
                                              color: Colors.green,
                                            ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                              )
                            else
                              Icon(
                                Icons.circle_outlined,
                                color: Colors.grey[300],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    if (index >= addresses.length - 1) {
                      return const SizedBox.shrink();
                    }
                    return const Divider(height: 1);
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

// Optional: Statistic chip widget
class _StatisticChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatisticChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: color, fontSize: 10),
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
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           BottomSheetTitle(title: AppStrings.selectAddress),
//
//           HomePageSearchWidget(
//             searchCtrl: _searchCtrl,
//             onSearch: () => setState(() {}), // фильтр по тексту
//           ),
//
//           const SizedBox(height: 10),
//
//           Expanded(
//             child: BlocBuilder<AddressesBloc, AddressesState>(
//               builder: (context, state) {
//                 if (state is AddressesLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (state is AddressesError) {
//                   return Center(child: Text(state.message));
//                 }
//
//                 final items = state is AddressesLoaded
//                     ? (state.addresses.data ?? <AddressData>[])
//                     : <AddressData>[];
//
//                 // простой поиск
//                 final q = _searchCtrl.text.trim().toLowerCase();
//                 final filtered = q.isEmpty
//                     ? items
//                     : items.where((a) {
//                   final addr = (a.address ?? '').toLowerCase();
//                   return addr.contains(q);
//                 }).toList();
//
//                 if (filtered.isEmpty) {
//                   return const Center(child: Text('Ничего не найдено'));
//                 }
//
//                 return ListView.separated(
//                   itemCount: filtered.length,
//                   itemBuilder: (context, index) {
//                     final item = filtered[index];
//                     final addr = item.address ?? '';
//
//                     return SelectItemWidget(
//                       index: index,
//                       services: filtered.map((e) => e.address ?? '').toList(),
//                       onSelectItem: (_) => widget.onSelectItem(addr),
//                       isSelected: widget.isSelected,
//                     );
//                   },
//                   separatorBuilder: (_, __) => const Divider(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
