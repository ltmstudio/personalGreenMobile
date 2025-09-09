import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/common/widgets/main_btn.dart';
import 'package:hub_dom/common/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/src/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/src/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/src/presentation/widgets/date_widgets/date_widget.dart';
import 'package:hub_dom/src/presentation/widgets/filter_widget.dart';
import 'package:hub_dom/src/presentation/widgets/image_picker_widget.dart';

import 'components/address_widget.dart';
import 'components/performer_widget.dart';
import 'components/select_time_widget.dart';
import 'components/services_widget.dart';
import 'components/urgency_category_widget.dart';
import 'components/work_type_widget.dart';

class CreateApplicationPage extends StatefulWidget {
  const CreateApplicationPage({super.key});

  @override
  State<CreateApplicationPage> createState() => _CreateApplicationPageState();
}

class _CreateApplicationPageState extends State<CreateApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.createApplication)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppStrings.applicationData,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.address,
                child: SelectBtn(
                  title: AppStrings.selectAddress,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: _showAddress,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.service,
                child: SelectBtn(
                  title: AppStrings.selectService,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: _showService,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.workType,
                child: SelectBtn(
                  title: AppStrings.selectWorkType,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: _showWorkType,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.categoryType,
                child: SelectBtn(
                  title: AppStrings.selectCategoryType,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: _showUrgency,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.doUntil,
                child: SelectBtn(
                  title: AppStrings.selectDate,
                  icon: Icon(Icons.calendar_today_outlined),
                  onTap: _showTime,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.performer,
                child: SelectBtn(
                  title: AppStrings.selectPerformer,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: _showPerformer,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.contactPerson,
                child: SelectBtn(
                  title: AppStrings.selectContactPerson,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.phoneContactPerson,
                child: SelectBtn(
                  title: AppStrings.phoneHintText,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.additionalPhoneContactPerson,
                child: SelectBtn(
                  title: AppStrings.phoneHintText,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(title: AppStrings.comments, child: SizedBox()),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppStrings.photoObject,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppStrings.upload10Photo,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 6),
            MultiImagePickerWidget(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MainButton(
                buttonTile: AppStrings.createNewApplication,
                onPressed:_showSuccess,
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAddress() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: AddressWidget(),
    );
  }

  _showService() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: ServicesWidget(),
    );
  }

  _showWorkType() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: WorkTypeWidget(),
    );
  }

  _showUrgency() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: UrgencyCategoryWidget(),
    );
  }

  _showTime() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: SelectTimeWidget(),
    );
  }

  _showPerformer() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(),
    );
  }

  _showSuccess() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            BottomSheetTitle(title: AppStrings.selectPerformer),
            SizedBox(height: 80),
            SvgPicture.asset(IconAssets.success,height: 140,width: 140,),
            SizedBox(height: 80),

            Text(
              'Заявка назначена на выбранного исполнителя и ожидает выполнения',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
