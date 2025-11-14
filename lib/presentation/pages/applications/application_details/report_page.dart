import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/confirm_bottomsheet.dart';
import 'package:hub_dom/presentation/widgets/reject_bottom_sheet.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';

class AppDetailsReportPage extends StatefulWidget {
  const AppDetailsReportPage({
    super.key,
    this.ticketData,
    this.selectedExecutorId,
    this.ticketId,
  });

  final Data? ticketData;
  final int? selectedExecutorId;
  final int? ticketId;

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
                    AppStrings.conclusion,
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
                    AppStrings.photoReport,
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

              return Row(
                children: [
                  Expanded(
                    child: MainButton(
                      buttonTile: AppStrings.reject,
                      onPressed: widget.ticketId != null && !isProcessing
                          ? () => _confirmReject(context, widget.ticketId!)
                          : null,
                      isLoading: state is ApplicationDetailsRejecting,
                      btnColor: AppColors.red,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MainButton(
                      buttonTile: AppStrings.confirm,
                      onPressed: widget.ticketId != null && !isProcessing
                          ? () => _handleConfirm(context, widget.ticketId!)
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
