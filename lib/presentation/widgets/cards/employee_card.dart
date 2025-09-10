import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.ratio,
  });

  final String name;
  final String role;
  final String ratio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push('${AppRoutes.performerDetails}/$name');
      },
      child: Card(
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
          ),
          subtitle: Text(role, style: Theme.of(context).textTheme.bodySmall),
          trailing: Text(
            ratio,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
