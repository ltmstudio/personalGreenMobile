import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/time_format.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/address_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/performer_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/select_time_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/services_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/urgency_category_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/work_type_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';

class CreateEmployeeAppPage extends StatefulWidget {
  const CreateEmployeeAppPage({super.key});

  @override
  State<CreateEmployeeAppPage> createState() => _CreateEmployeeAppPageState();
}

class _CreateEmployeeAppPageState extends State<CreateEmployeeAppPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? selectedAddress;

  String? selectedService;
  String? selectedWorkType;
  String? selectedUrgency;

  String? formattedTime;

  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedService = null;
    selectedWorkType = null;
    selectedUrgency = null;
    selectedDate = null;
    selectedTime = null;
    selectedAddress = null;
    formattedTime = null;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDate != null || selectedTime != null) {
      formattedTime = formattedDateTime(selectedDate, selectedTime);
    }
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
                  value: selectedAddress,
                  icon: Icon(Icons.keyboard_arrow_down),
                  showBorder: true,

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
                  value: selectedService,
                  icon: Icon(Icons.keyboard_arrow_down),
                  showBorder: true,
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
                  value: selectedWorkType,
                  icon: Icon(Icons.keyboard_arrow_down),
                  showBorder: true,

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
                  value: selectedUrgency,
                  icon: Icon(Icons.keyboard_arrow_down),
                  showBorder: true,

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
                  value: formattedTime,
                  icon: Icon(Icons.calendar_today_outlined),
                  showBorder: true,

                  onTap: _showTime,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.additionalPhoneContactPerson,
                child: KTextField(
                  controller: _phoneCtrl,
                  isSubmitted: false,
                  keyboardType: TextInputType.number,
                  hintText: AppStrings.phoneHintText,
                  borderColor: AppColors.lightGrayBorder,
                  filled: true,
                ),
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFieldTitle(
                title: AppStrings.comments,
                child: KTextField(
                  controller: _commentCtrl,
                  isSubmitted: false,
                  hintText: AppStrings.addComments,
                  borderColor: AppColors.lightGrayBorder,
                  filled: true,
                  maxLines: 3,
                ),
              ),
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
                onPressed: _showSuccess,
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
      child: AddressWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedAddress = value;
          });
        },
        isSelected: true,
      ),
    );
  }

  _showService() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: ServicesWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedService = value;
          });
        },
        isSelected: true,
      ),
    );
  }

  _showWorkType() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: WorkTypeWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedWorkType = value;
          });
        },
        isSelected: true,
      ),
    );
  }

  _showUrgency() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: UrgencyCategoryWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedUrgency = value;
          });
        },
        isSelected: true,
      ),
    );
  }

  _showTime() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: SelectTimeWidget(
        onSelectDate: (DateTime value) {
          setState(() {
            selectedDate = value;
          });
        },
        onSelectTime: (TimeOfDay value) {
          setState(() {
            selectedTime = value;
          });
        },
        onClear: () {
          setState(() {
            selectedDate = null;
            selectedTime = null;
          });
        },
      ),
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
            SvgPicture.asset(IconAssets.success, height: 140, width: 140),
            SizedBox(height: 80),

            Text(
              'Заявка назначена на выбранного исполнителя и ожидает выполнения',
              textAlign: TextAlign.center,
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
