import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({super.key, this.ticketData});

  final Data? ticketData;

  @override
  Widget build(BuildContext context) {
    final address = ticketData?.object?.address ?? 'Данных нет';
    final region = ticketData?.object?.region?.name ?? '';
    final regionType = ticketData?.object?.region?.typeShort ?? '';
    final cityType = ticketData?.object?.city?.typeShort ?? '';
    final city = ticketData?.object?.city?.name ?? '';
    final section = ticketData?.section ?? 'Данных нет';
    final ls = ticketData?.object?.ls ?? 'Данных нет';

    final regionTitle = ', $regionType $region';
    final cityTitle = ', $cityType $city';

    return MainCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$address$regionTitle$cityTitle',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.timeColor,
                ),
                child: Icon(Icons.location_on_outlined, color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            AppStrings.plot,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text(
            section,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (ls != 'Данных нет') ...[
            SizedBox(height: 12),
            Text(
              'Лицевой счет',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 4),
            Text(
              ls,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
