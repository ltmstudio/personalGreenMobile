import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/color_utils.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/tickets/ticket_response_model.dart';

class AppItemCard extends StatelessWidget {
  const AppItemCard({super.key, required this.isManager, this.ticket});

  final bool isManager;
  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isManager) {
          final ticketId = ticket?.id;
          if (ticketId != null) {
            context.push('${AppRoutes.applicationDetails}/$ticketId');
          } else {
            context.push(AppRoutes.applicationDetails);
          }
        } else {
          final ticketId = ticket?.id ?? 123;
          context.push(
            '${AppRoutes.employeeAppDetails}/Заявка №$ticketId',
            extra: {'ticketId': ticketId},
          );
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
                  Expanded(
                    child: Row(
                      children: [
                        // Цветная точка на основе статуса или красная по умолчанию
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: _getStatusColor(),
                        ),
                        const SizedBox(width: 8),
                        // Название заявки из service_type.title или по умолчанию
                        Expanded(
                          child: Text(
                            _getServiceTypeTitle(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Время создания или по умолчанию
                  Text(
                    _getFormattedTime(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Адрес или по умолчанию
              Text(
                _getAddress(),
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Получает цвет статуса из hex строки или красный по умолчанию
  Color _getStatusColor() {
    if (ticket?.status?.color != null) {
      return ColorUtils.hexToColor(ticket!.status!.color!);
    }
    return AppColors.red;
  }

  /// Получает название типа услуги или по умолчанию
  String _getServiceTypeTitle() {
    return ticket?.serviceType?.title ?? 'Перепады напряжения';
  }

  /// Получает отформатированное время или по умолчанию
  String _getFormattedTime() {
    if (ticket?.createdAt != null) {
      return DateTimeUtils.formatTimeForCard(ticket!.createdAt!);
    }
    return '18:28';
  }

  /// Получает адрес или по умолчанию
  String _getAddress() {
    if (ticket?.address != null) {
      final ticketId = ticket?.id ?? '';
      return '№$ticketId  ${ticket!.address!}';
    }
    return '№3  г. Воронеж, ул. Грамши, д. 57, кв. 55';
  }
}
