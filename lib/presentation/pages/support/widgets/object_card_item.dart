import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';

class ObjectItemWidget extends StatelessWidget {
  const ObjectItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.subTitle,
  });

  final String title;
  final String subTitle;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => context.push(AppRoutes.objectDetails),
      child: MainCardWidget(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: SvgPicture.asset(icon, width: 20, height: 20),
            ),

            // ВАЖНО: Flexible, чтобы правая часть реально ужималась
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


