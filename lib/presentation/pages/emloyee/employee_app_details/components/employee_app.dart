import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/application_details_page.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/address_card_widget.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/application_detail_data_card.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/check_list_widget.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/contact_face_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';

import 'create_performer_widget.dart';

class EmployeeAppsPage extends StatefulWidget {
  const EmployeeAppsPage({super.key});

  @override
  State<EmployeeAppsPage> createState() => _EmployeeAppsPageState();
}

class _EmployeeAppsPageState extends State<EmployeeAppsPage> {
  String? selectedPerformer;

  String? selectedContact;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedContact = null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  _showPerformer() async {
    if (selectedPerformer != null) {
      _nameCtrl.text = selectedPerformer!;
    }
    if (selectedContact != null) {
      _phoneCtrl.text = selectedContact!;
    }
    final result = await bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: CreatePerformerWidget(
        nameCtrl: _nameCtrl,
        phoneCtrl: _phoneCtrl,
        onAdded: ((String, String) pair) {
          setState(() {
            selectedPerformer = pair.$1;
            selectedContact = pair.$2;
          });
        },
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        selectedPerformer = result['name'];
        selectedContact = result['phone'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppStrings.applicationData,
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
              value: selectedPerformer,
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
              onTap: _showPerformer,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ApplicationDetailDataCard(),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ContactFaceCardWidget(),
          ),

          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AddressCardWidget(),
          ),

          SizedBox(height: 16),

          ExpansionTile(
            title: Text(
              AppStrings.action,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            initiallyExpanded: true,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            // optional
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
              AppStrings.photoObject,
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
                  child: ImageWithShimmer(imageUrl: img, width: 70, height: 70),
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 6),
              itemCount: 10,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // _confirmAccept() {
  //   bottomSheetWidget(
  //     context: context,
  //     isScrollControlled: false,
  //     child: ConfirmBottomSheet(title: 'Подтвердить заявку?', body: 'Вы уверены, что хотите подтвердить заявку? Данное действие нельзя будет отменить', onTap: () {  },),
  //   );
  // }
}
