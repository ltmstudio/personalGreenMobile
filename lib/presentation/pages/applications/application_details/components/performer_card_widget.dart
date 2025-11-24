import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class PerformerCardWidget extends StatelessWidget {
  const PerformerCardWidget({
    super.key,
    this.ticketData,
    this.selectedPerformer,
  });

  final Data? ticketData;
  final String? selectedPerformer;

  @override
  Widget build(BuildContext context) {
    // Получаем имя исполнителя из данных заявки или из selectedPerformer
    String performerName = 'Данных нет';
    if (ticketData?.executor != null) {
      performerName = ticketData!.executor!.fullName;
    } else if (selectedPerformer != null && selectedPerformer!.isNotEmpty) {
      performerName = selectedPerformer!;
    }

    return MainCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.performer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text(
            performerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

