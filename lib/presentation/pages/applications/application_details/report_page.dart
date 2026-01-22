import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/application_details/application_details_bloc.dart';
import 'package:hub_dom/presentation/bloc/ticket_report/ticket_report_cubit.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/confirm_bottomsheet.dart';
import 'package:hub_dom/presentation/widgets/reject_bottom_sheet.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';
import 'package:hub_dom/presentation/widgets/toast_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';

import '../../../../data/models/tickets/ticket_report_model.dart';

class AppDetailsReportPage extends StatefulWidget {
  const AppDetailsReportPage({super.key, this.ticketData, this.ticketId});

  final Data? ticketData;
  final int? ticketId;

  @override
  State<AppDetailsReportPage> createState() => _AppDetailsReportPageState();
}

class _AppDetailsReportPageState extends State<AppDetailsReportPage> {
  @override
  void initState() {
    super.initState();
    locator<ReportsCubit>().load(ticketId: widget.ticketId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Отчет')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

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
                      widget.ticketData?.comment ?? '',
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

                  _buildPhotosSection(context,widget.ticketData?.photos??[]),
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
            child:
                BlocConsumer<ApplicationDetailsBloc, ApplicationDetailsState>(
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
                                ? () =>
                                      _confirmReject(context, widget.ticketId!)
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
                                ? () =>
                                      _handleConfirm(context, widget.ticketId!)
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
      ),
    );
  }

  void _handleConfirm(BuildContext context, int ticketId) {
    // Проверяем наличие отчета (comment или photos)
    final hasReport =
        (widget.ticketData?.comment?.trim().isNotEmpty ?? false) ||
            ((widget.ticketData?.photos.isNotEmpty ?? false));


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

  Widget _buildPhotosSection(BuildContext context, List<Photo> photos) {
    final urls = photos
        .map((e) => (e.link ?? '').trim())
        .where((u) => u.isNotEmpty)
        .toList();

    if (urls.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Нет данных',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.gray),
        ),
      );
    }

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageWithShimmer(
              imageUrl: urls[index],
              width: 70,
              height: 70,
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 6),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final TicketReport report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final title = reportTitleByType(report.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                report.createdAt,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                report.comment,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String reportTitleByType(String type) {
  switch (type) {
    case 'responsible':
      return 'Отчет руководителя';
    case 'executor':
      return 'Отчет исполнителя';
    default:
      return 'Отчет';
  }
}
