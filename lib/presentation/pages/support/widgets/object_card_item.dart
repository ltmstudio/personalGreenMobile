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
      onTap: (){
        context.push(AppRoutes.objectDetails);
      },
      child: MainCardWidget(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),

                SizedBox(height: 4),
                Text(subTitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
