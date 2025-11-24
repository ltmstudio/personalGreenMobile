import 'package:flutter/foundation.dart';
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
import 'components/performer_card_widget.dart';
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
                // Показываем выбор исполнителя только если исполнитель не выбран
                if (widget.selectedPerformer == null && 
                    widget.selectedExecutorId == null && 
                    widget.ticketData?.executor == null)
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
                // Всегда показываем карточку исполнителя
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PerformerCardWidget(
                    ticketData: widget.ticketData,
                    selectedPerformer: widget.selectedPerformer,
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
                // Показываем выбор контактного лица только если контактное лицо не выбрано
                if (widget.selectedContact == null && widget.ticketData?.resident == null)
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

                // Всегда показываем карточку контактного лица
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

                _buildPhotosSection(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // Показываем кнопки только если статус тикета "контроль"
        if (widget.ticketData?.status?.name == 'control')
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

  Widget _buildPhotosSection(BuildContext context) {
    final photos = widget.ticketData?.photos;
    
    // Логируем для отладки
    if (photos != null) {
      debugPrint('Photos data type: ${photos.runtimeType}');
      debugPrint('Photos data: $photos');
    }

    // Проверяем разные форматы данных photos
    List<String> photoUrls = [];
    
    if (photos != null) {
      if (photos is List) {
        for (final photo in photos) {
          String? url;
          if (photo is String) {
            // Если это строка - используем как URL
            url = photo;
          } else if (photo is Map) {
            // Если это объект - пытаемся извлечь URL из разных полей
            url = photo['link'] ?? 
                  photo['url'] ?? 
                  photo['path'] ?? 
                  photo['image_url'] ?? 
                  photo['photo_url'] ??
                  photo['src'];
          }
          
          if (url != null && url.isNotEmpty) {
            photoUrls.add(url);
          }
        }
      }
    }

    if (photoUrls.isNotEmpty) {
      return SizedBox(
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: photoUrls.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageWithShimmer(
                imageUrl: photoUrls[index],
                width: 70,
                height: 70,
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(width: 6),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Нет данных',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.gray),
        ),
      );
    }
  }
}
