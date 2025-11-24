import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class ContactFaceCardWidget extends StatelessWidget {
  const ContactFaceCardWidget({super.key, this.ticketData});

  final Data? ticketData;

  @override
  Widget build(BuildContext context) {
    final resident = ticketData?.resident;
    final residentName = resident != null
        ? (resident is String ? resident : resident.toString())
        : 'Данных нет';
    final contactPhone = ticketData?.contactPhone;
    final phone = contactPhone != null
        ? (contactPhone is String ? contactPhone : contactPhone.toString())
        : 'Данных нет';

    return MainCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.contactPerson,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text(
            residentName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 12),
          _contactNumberWidget(
            context,
            AppStrings.mainPhone,
            phone,
          ),
        ],
      ),
    );
  }

  _contactNumberWidget(BuildContext context, String title, String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 4),
              Text(
                phone,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green,
          ),
          child: SvgPicture.asset(IconAssets.call),
        ),
      ],
    );
  }
}
