import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'г. Воронеж, ЖК «Тестовый», ул. Краснознаменная, д. 62а',
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
                child: Icon(Icons.location_on_outlined,color: AppColors.white,),
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
            AppStrings.homeBuilder,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
