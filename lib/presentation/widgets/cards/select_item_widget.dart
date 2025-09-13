import 'package:flutter/material.dart';

class SelectItemWidget extends StatelessWidget {
  const SelectItemWidget({
    super.key,
    required this.index,
    required this.services,
    required this.onSelectItem,
    required this.isSelected,
  });

  final int index;
  final List<String> services;
  final ValueChanged<String> onSelectItem;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectItem(services[index]);
        if (isSelected) {
          Navigator.of(context).pop();
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: Text(
          services[index],
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
