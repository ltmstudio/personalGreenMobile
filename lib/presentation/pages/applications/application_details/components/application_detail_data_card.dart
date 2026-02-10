import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/color_utils.dart';
import 'package:hub_dom/core/utils/date_time_utils.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class ApplicationDetailDataCard extends StatelessWidget {
  const ApplicationDetailDataCard({super.key, this.ticketData});

  final Data? ticketData;

  @override
  Widget build(BuildContext context) {
    final serviceType = ticketData?.serviceType?.title ?? 'Данных нет';
    final createdAt = ticketData?.createdAt != null
        ? DateTimeUtils.formatDateTime(ticketData!.createdAt!)
        : 'Данных нет';
    final troubleType = ticketData?.troubleType?.title ?? 'Данных нет';
    final priorityType = ticketData?.priorityType;
    final priorityTitle = priorityType?.title ?? 'Данных нет';
    final priorityColor = priorityType?.color != null
        ? ColorUtils.hexToColor(priorityType!.color!)
        : AppColors.gray;
    String visitingAt = 'Данных нет';
    if (ticketData?.visitingAt != null) {
      try {
        if (ticketData!.visitingAt is DateTime) {
          visitingAt = DateTimeUtils.formatDateTime(
            ticketData!.visitingAt as DateTime,
          );
        } else if (ticketData!.visitingAt is String) {
          final dateTime = DateTime.parse(ticketData!.visitingAt as String);
          visitingAt = DateTimeUtils.formatDateTime(dateTime);
        } else {
          visitingAt = ticketData!.visitingAt.toString();
        }
      } catch (e) {
        visitingAt = ticketData!.visitingAt.toString();
      }
    }
    final comment = ticketData?.comment ?? 'Данных нет';

    return MainCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                createdAt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            troubleType,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: priorityColor),
                  const SizedBox(width: 8),
                  Text(
                    priorityTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          if (ticketData?.visitingAt != null) ...[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Выполнить до',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  visitingAt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          if (comment != 'Данных нет') ...[
            SizedBox(height: 12),
            Text(comment, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
