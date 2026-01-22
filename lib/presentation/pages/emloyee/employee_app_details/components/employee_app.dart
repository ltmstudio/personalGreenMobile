import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart' hide WorkUnit;
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/address_card_widget.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/application_detail_data_card.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/contact_face_widget.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:get_it/get_it.dart';
import 'package:hub_dom/presentation/widgets/shimmer_image.dart';

import 'create_performer_widget.dart';
import 'work_units_widget.dart';

class EmployeeAppsPage extends StatefulWidget {
  final Data? ticketData;

  const EmployeeAppsPage({super.key, this.ticketData});

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
              title: AppStrings.selectContactPerson,
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

          BlocProvider(
            create: (context) {
              final bloc = GetIt.instance<DictionariesBloc>();
              bloc.add(const LoadDictionariesEvent());
              return bloc;
            },
            child: BlocBuilder<DictionariesBloc, DictionariesState>(
              builder: (context, dictionariesState) {
                List<WorkUnit> workUnits = [];

                if (dictionariesState is DictionariesLoaded &&
                    widget.ticketData?.troubleType?.id != null) {
                  final troubleTypeId = widget.ticketData!.troubleType!.id;

                  // Ищем trouble_type в словарях
                  final allTroubleTypes =
                      dictionariesState.dictionaries.troubleTypes ?? [];
                  final troubleType = allTroubleTypes.firstWhere(
                    (tt) => tt.id == troubleTypeId,
                    orElse: () => TroubleType(),
                  );

                  workUnits = troubleType.workUnits ?? [];
                }

                return ExpansionTile(
                  title: Text(
                    AppStrings.action,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  initiallyExpanded: true,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: MainCardWidget(
                        child: workUnits.isEmpty
                            ? Center(
                                child: Text(
                                  'Нет доступных работ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.gray),
                                ),
                              )
                            : WorkUnitsWidget(workUnits: workUnits),
                      ),
                    ),
                  ],
                );
              },
            ),
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

          _buildPhotosSection(context,widget.ticketData?.photos??[]),


          SizedBox(height: 20),
        ],
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

  // _confirmAccept() {
  //   bottomSheetWidget(
  //     context: context,
  //     isScrollControlled: false,
  //     child: ConfirmBottomSheet(title: 'Подтвердить заявку?', body: 'Вы уверены, что хотите подтвердить заявку? Данное действие нельзя будет отменить', onTap: () {  },),
  //   );
  // }
}
