import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class SupportItemWidget extends StatelessWidget {
  const SupportItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.subTitle, this.onTap,
  });

  final String title;
  final String? subTitle;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subTitle != null)

                SizedBox(height: 4),
              if (subTitle != null)
                Text(
                  subTitle ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: SvgPicture.asset(icon),
            ),
          ),
        ],
      ),
    );
  }
}
