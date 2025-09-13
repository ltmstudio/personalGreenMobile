import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

import 'application_details_page.dart';


class AppDetailsReportPage extends StatefulWidget {
  const AppDetailsReportPage({super.key});

  @override
  State<AppDetailsReportPage> createState() => _AppDetailsReportPageState();
}

class _AppDetailsReportPageState extends State<AppDetailsReportPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Заключение",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Устранены повреждения кабеля, произведена замена проблемного кабеля с установкой защитной муфты",

                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Фотоотчёт",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 14),

                SizedBox(
                  height: 70,

                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageWithShimmer(
                          imageUrl: img,
                          width: 70,
                          height: 70,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 6),
                    itemCount: 10,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: MainButton(
                  buttonTile: 'Отклонить',
                  onPressed: () {},
                  isLoading: false,
                  btnColor: AppColors.red,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MainButton(
                  buttonTile: 'Назначить',
                  onPressed: () => Toast.show(
                    context,
                    "Выберите исполнителя и контактное лицо",
                  ),
                  isLoading: false,
                  btnColor: AppColors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
