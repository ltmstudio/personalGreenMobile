import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class AppItemCard extends StatelessWidget {
  const AppItemCard({super.key, required this.isManager});
  final bool isManager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(isManager){
          context.push(AppRoutes.applicationDetails);

        }else{
          context.push('${AppRoutes.employeeAppDetails}/Заявка №123');

        }
      },
      child: Card(
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: AppColors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Перепады напряжения',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium,
                    ),
                  ],
                ),
                  Text(
                    '18:28',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text('№3  г. Воронеж, ул. Грамши, д. 57, кв. 55', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
