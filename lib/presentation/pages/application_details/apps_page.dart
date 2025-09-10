import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/confirm_bottomsheet.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

import 'application_details_page.dart';
import 'components/address_card_widget.dart';
import 'components/application_detail_data_card.dart';
import 'components/check_list_widget.dart';
import 'components/contact_face_widget.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({
    super.key,
    required this.selectedPerformer,
    required this.selectedContact,
    required this.onShowPerformer,
    required this.onShowContact,
  });

  final String? selectedPerformer;
  final String? selectedContact;
  final VoidCallback onShowPerformer;
  final VoidCallback onShowContact;

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
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
                    "Данные заявки",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SelectBtn(
                    title: AppStrings.selectPerformer,
                    value: widget.selectedPerformer,
                    showBorder: false,
                    icon: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGrayBorder,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                        color: AppColors.white,
                      ),
                    ),
                    onTap: widget.onShowPerformer,
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ApplicationDetailDataCard(),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SelectBtn(
                    title: AppStrings.selectContactPerson,
                    value: widget.selectedContact,
                    showBorder: false,
                    icon: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGrayBorder,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                        color: AppColors.white,
                      ),
                    ),
                    onTap: widget.onShowContact,
                  ),
                ),
                SizedBox(height: 6),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AddressCardWidget(),
                ),
                SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ContactFaceCardWidget(),
                ),
                SizedBox(height: 16),

                ExpansionTile(
                  title: Text(
                    "Действия",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  initiallyExpanded: true,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  // optional
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: MainCardWidget(child: ChecklistWidget()),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Фото объекта",
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
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: MainButton(
                  buttonTile: 'Отклонить',
                  onPressed: _confirmAccept,
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

  _confirmAccept() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: ConfirmBottomSheet(title: 'Подтвердить заявку?', body: 'Вы уверены, что хотите подтвердить заявку? Данное действие нельзя будет отменить', onTap: () {  },),
    );
  }
}
