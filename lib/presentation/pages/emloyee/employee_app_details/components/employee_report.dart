import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/application_details_page.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

class EmployeeReportPage extends StatefulWidget {
  const EmployeeReportPage({super.key});

  @override
  State<EmployeeReportPage> createState() => _EmployeeReportPageState();
}

class _EmployeeReportPageState extends State<EmployeeReportPage> {
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

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
                  child: KTextField(
                    controller: _textCtrl,
                    isSubmitted: false,
                    filled: true,
                    borderColor: AppColors.lightGrayBorder,
                    maxLines: 3,
                    hintText: 'Напишите заключение',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    AppStrings.upload10Photo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 14),
                MultiImagePickerWidget(),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
          child: MainButton(
            buttonTile: 'Завершить заявку',
            onPressed: (){},
            isLoading: false,
          ),
        ),
      ],
    );
  }
}
