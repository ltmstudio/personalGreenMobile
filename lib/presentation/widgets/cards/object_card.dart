import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class ObjectCard extends StatelessWidget {
  const ObjectCard({super.key, required this.address, required this.stats});

  final String address;
  final Map<String, int> stats;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push('${AppRoutes.addressDetails}/$address');
        context.push(AppRoutes.addressDetails);

      },
      child: Card(
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dotStat(context, Colors.blue, stats["blue"]!),
                  const SizedBox(width: 25),
                  _dotStat(context, Colors.red, stats["red"]!),
                  const SizedBox(width: 25),
                  _dotStat(context, Colors.green, stats["green"]!),
                  const SizedBox(width: 25),
                  _dotStat(context, Colors.orange, stats["orange"]!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dotStat(BuildContext context, Color color, int value) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
