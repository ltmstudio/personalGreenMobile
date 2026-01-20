
import 'package:flutter/material.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/search_widgets/search_widget.dart';

class ContactPickerWidget extends StatefulWidget {
  const ContactPickerWidget({
    super.key,
    required this.contacts,
    required this.onSelectItem,
    required this.isSelected,
    this.onSelectContact,
    this.title,
    this.searchHint,
    this.emptyText,
    this.minSearchLength = 2,
  });

  final List<Contact> contacts;

  /// What will be written into your input (by default: phone number).
  final ValueChanged<String> onSelectItem;

  final ValueChanged<Contact>? onSelectContact;
  final bool isSelected;

  final String? title;
  final String? searchHint;
  final String? emptyText;

  final int minSearchLength;

  @override
  State<ContactPickerWidget> createState() => _ContactPickerWidgetState();
}

class _ContactPickerWidgetState extends State<ContactPickerWidget> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

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
    final q = _searchCtrl.text.trim();
    if (q == _query) return;
    setState(() => _query = q);
  }

  List<Contact> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.contacts;

    // optional: don’t filter if too short
    if (q.length < widget.minSearchLength) return widget.contacts;

    return widget.contacts.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final number = (c.number ?? '').toLowerCase();
      return title.contains(q) || number.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: widget.title ?? 'Выберите контакт'),
          HomePageSearchWidget(
            hint: widget.searchHint ?? 'Поиск по имени или номеру',
            searchCtrl: _searchCtrl,
            onSearch: () => _onSearchChanged(),
            onClear: () {
              _searchCtrl.clear();
              _onSearchChanged();
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? Center(
              child: Text(
                widget.emptyText ?? 'Контакты не найдены',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
                : ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final contact = items[index];

                final title = (contact.title?.trim().isNotEmpty ?? false)
                    ? contact.title.trim()
                    : 'Без названия';

                final number = (contact.number?.trim().isNotEmpty ?? false)
                    ? contact.number.trim()
                    : 'Номер не указан';

                // What to return into parent input
                final selectValue = number; // or '$title — $number'

                return InkWell(
                  onTap: () {
                    widget.onSelectItem(selectValue);
                    widget.onSelectContact?.call(contact);

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
                          title,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          number,
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
            ),
          ),
        ],
      ),
    );
  }
}


