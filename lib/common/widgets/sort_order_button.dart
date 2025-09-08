import 'package:flutter/material.dart';

class SortOrderSelector extends StatelessWidget {
  final String sortOrder; // "asc" or "desc"
  final ValueChanged<String> onChanged;
  final bool isIconOnly;

  const SortOrderSelector({
    super.key,
    required this.sortOrder,
    required this.onChanged,
    this.isIconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: sortOrder,
      onSelected: onChanged,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "asc",
          child: Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green),
              SizedBox(width: 8),
              Text("По возрастанию"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "desc",
          child: Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.red),
              SizedBox(width: 8),
              Text("По убыванию"),
            ],
          ),
        ),
      ],
      child: isIconOnly
          ? const Icon(Icons.sort)
          : Container(
        width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  sortOrder == "asc"
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: sortOrder == "asc" ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sortOrder == "asc"
                        ? "По возрастанию"
                        : "По убыванию",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
    );
  }
}
