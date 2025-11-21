import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/confirm_bottomsheet.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';

import 'components/address_card_widget.dart';
import 'components/application_detail_data_card.dart';
import 'components/check_list_widget.dart';
import 'components/contact_face_widget.dart';
import 'package:hub_dom/presentation/widgets/reject_bottom_sheet.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({
    super.key,
    this.ticketData,
    required this.selectedPerformer,
    required this.selectedContact,
    this.selectedExecutorId,
    required this.onShowPerformer,
    required this.onShowContact,
  });

  final Data? ticketData;
  final String? selectedPerformer;
  final String? selectedContact;
  final int? selectedExecutorId;
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
                  child: ApplicationDetailDataCard(
                    ticketData: widget.ticketData,
                  ),
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
                  child: AddressCardWidget(ticketData: widget.ticketData),
                ),
                SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ContactFaceCardWidget(ticketData: widget.ticketData),
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
                    AppStrings.photoObject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 14),

                widget.ticketData?.photos != null &&
                        (widget.ticketData!.photos is List) &&
                        (widget.ticketData!.photos as List).isNotEmpty
                    ? SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: (widget.ticketData!.photos as List).length,
                          itemBuilder: (context, index) {
                            final photo =
                                (widget.ticketData!.photos as List)[index];
                            final photoUrl = photo is String
                                ? photo
                                : photo.toString();
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageWithShimmer(
                                imageUrl: photoUrl,
                                width: 70,
                                height: 70,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 6),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Данных нет',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray),
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
          child: BlocConsumer<ApplicationDetailsBloc, ApplicationDetailsState>(
            listener: (context, state) {
              if (state is ApplicationDetailsAccepted) {
                Toast.show(context, 'Заявка принята');
                Navigator.of(context).pop();
              } else if (state is ApplicationDetailsRejected) {
                Toast.show(context, 'Заявка отклонена');
                Navigator.of(context).pop();
              } else if (state is ApplicationDetailsError) {
                Toast.show(context, state.message);
              }
            },
            builder: (context, state) {
              final isProcessing =
                  state is ApplicationDetailsAccepting ||
                  state is ApplicationDetailsRejecting;
              final ticketId = widget.ticketData?.id;

              return Row(
                children: [
                  Expanded(
                    child: MainButton(
                      buttonTile: AppStrings.reject,
                      onPressed: ticketId != null && !isProcessing
                          ? () => _confirmReject(context, ticketId)
                          : null,
                      isLoading: state is ApplicationDetailsRejecting,
                      btnColor: AppColors.red,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MainButton(
                      buttonTile: AppStrings.confirm,
                      onPressed: ticketId != null && !isProcessing
                          ? () => _handleConfirm(context, ticketId)
                          : null,
                      isLoading: state is ApplicationDetailsAccepting,
                      btnColor: AppColors.green,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleConfirm(BuildContext context, int ticketId) {
    // Проверяем наличие отчета (comment или photos)
    final hasReport =
        widget.ticketData?.comment != null &&
            widget.ticketData!.comment.toString().isNotEmpty ||
        (widget.ticketData?.photos != null &&
            widget.ticketData!.photos is List &&
            (widget.ticketData!.photos as List).isNotEmpty);

    if (hasReport) {
      // Если есть отчет, показываем диалог подтверждения
      _confirmAccept(context, ticketId);
    } else {
      // Если отчета нет, сразу отправляем запрос
      context.read<ApplicationDetailsBloc>().add(AcceptTicketEvent(ticketId));
    }
  }

  void _confirmAccept(BuildContext context, int ticketId) {
    bottomSheetWidget(
      context: context,
      isScrollControlled: false,
      child: ConfirmBottomSheet(
        title: AppStrings.confirmReport,
        body: AppStrings.confirmReportBody,
        confirmButtonText: AppStrings.confirm,
        onTap: () {
          context.read<ApplicationDetailsBloc>().add(
            AcceptTicketEvent(ticketId),
          );
        },
      ),
    );
  }

  void _confirmReject(BuildContext context, int ticketId) {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: RejectBottomSheet(
        onConfirm: (rejectReason) {
          context.read<ApplicationDetailsBloc>().add(
            RejectTicketEvent(ticketId, rejectReason: rejectReason),
          );
        },
      ),
    );
  }
}
