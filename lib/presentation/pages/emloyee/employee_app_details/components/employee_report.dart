import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/employee_report_request_model.dart';
import 'package:hub_dom/presentation/bloc/employee_report/employee_report_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';

class EmployeeReportPage extends StatefulWidget {
  const EmployeeReportPage({super.key, this.ticketId});

  final int? ticketId;

  @override
  State<EmployeeReportPage> createState() => _EmployeeReportPageState();
}

class _EmployeeReportPageState extends State<EmployeeReportPage> {
  final TextEditingController _textCtrl = TextEditingController();
  final List<XFile> _selectedImages = [];

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _onImagesChanged(List<XFile> images) {
    setState(() {
      _selectedImages.clear();
      _selectedImages.addAll(images);
    });
  }

  void _submitReport(BuildContext blocContext) {
    if (widget.ticketId == null) {
      Toast.show(blocContext, 'ID заявки не указан');
      return;
    }

    final comment = _textCtrl.text.trim();
    final photos = _selectedImages
        .map((xFile) => File(xFile.path))
        .where((file) => file.existsSync())
        .toList();

    if (comment.isEmpty && photos.isEmpty) {
      Toast.show(blocContext, 'Заполните комментарий или добавьте фотографии');
      return;
    }

    final request = EmployeeReportRequestModel(
      comment: comment.isNotEmpty ? comment : null,
      photos: photos.isNotEmpty ? photos : null,
    );

    blocContext.read<EmployeeReportBloc>().add(
      SubmitReportEvent(ticketId: widget.ticketId!, request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<EmployeeReportBloc>(),
      child: BlocListener<EmployeeReportBloc, EmployeeReportState>(
        listener: (context, state) {
          if (state is EmployeeReportSubmitted) {
            Toast.show(context, 'Отчет успешно отправлен');
            Navigator.of(context).pop();
          } else if (state is EmployeeReportError) {
            Toast.show(context, state.message);
          }
        },
        child: BlocBuilder<EmployeeReportBloc, EmployeeReportState>(
          builder: (blocContext, state) {
            final isLoading = state is EmployeeReportSubmitting;

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
                            AppStrings.conclusion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(blocContext).textTheme.bodyLarge,
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
                            hintText: AppStrings.addConclusion,
                            isEnabled: !isLoading,
                          ),
                        ),
                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            AppStrings.photoReport,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(blocContext).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            AppStrings.upload10Photo,
                            style: Theme.of(blocContext).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 14),
                        MultiImagePickerWidget(
                          onImagesChanged: _onImagesChanged,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30,
                  ),
                  child: MainButton(
                    buttonTile: AppStrings.closeApp,
                    onPressed: isLoading
                        ? null
                        : () => _submitReport(blocContext),
                    isLoading: isLoading,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
