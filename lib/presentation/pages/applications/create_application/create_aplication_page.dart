import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/time_format.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
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

class CreateApplicationPage extends StatefulWidget {
  const CreateApplicationPage({super.key});

  @override
  State<CreateApplicationPage> createState() => _CreateApplicationPageState();
}

class _CreateApplicationPageState extends State<CreateApplicationPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? selectedAddress;

  String? selectedService;
  String? selectedWorkType;
  String? selectedPerformer;
  String? selectedUrgency;

  String? formattedTime;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addPhoneCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();

  bool _shouldOpenAddressList = false;

  @override
  void initState() {
    super.initState();
    selectedService = null;
    selectedWorkType = null;
    selectedPerformer = null;
    selectedUrgency = null;
    selectedDate = null;
    selectedTime = null;
    selectedAddress = null;
    formattedTime = null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addPhoneCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDate != null || selectedTime != null) {
      formattedTime = formattedDateTime(selectedDate, selectedTime);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = locator<AddressesBloc>();
            bloc.add(const LoadAddressesEvent());
            return bloc;
          },
        ),
      ],
      child: Builder(
        builder: (context) => BlocListener<AddressesBloc, AddressesState>(
          listener: (context, state) {
            if (state is AddressesLoaded && _shouldOpenAddressList) {
              _shouldOpenAddressList = false;
              _openAddressList(context, state.addresses.data ?? []);
            } else if (state is AddressesError && _shouldOpenAddressList) {
              _shouldOpenAddressList = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: ${state.message}')),
              );
            }
          },
          child: Scaffold(
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
                      child: BlocBuilder<AddressesBloc, AddressesState>(
                        builder: (context, state) {
                          final isLoading = state is AddressesLoading;
                          return SelectBtn(
                            title: AppStrings.selectAddress,
                            value: selectedAddress,
                            icon: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(Icons.keyboard_arrow_down),
                            showBorder: true,
                            onTap: isLoading
                                ? () {}
                                : () => _showAddress(context),
                          );
                        },
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
                      title: AppStrings.performer,
                      child: SelectBtn(
                        title: AppStrings.selectPerformer,
                        value: selectedPerformer,
                        icon: Icon(Icons.keyboard_arrow_down),
                        showBorder: true,

                        onTap: _showPerformer,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFieldTitle(
                      title: AppStrings.contactPerson,
                      child: KTextField(
                        controller: _nameCtrl,
                        isSubmitted: false,
                        hintText: AppStrings.selectContactPerson,
                        borderColor: AppColors.lightGrayBorder,
                        filled: true,
                      ),
                    ),
                  ),
                  // SizedBox(height: 12),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: TextFieldTitle(
                  //     title: AppStrings.selectContactPerson,
                  //     child: KTextField(
                  //       controller: _phoneCtrl,
                  //       isSubmitted: false,
                  //       keyboardType: TextInputType.number,
                  //       hintText: AppStrings.phoneHintText,
                  //       borderColor: AppColors.lightGrayBorder,
                  //       filled: true,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFieldTitle(
                      title: AppStrings.additionalPhoneContactPerson,
                      child: KTextField(
                        controller: _addPhoneCtrl,
                        keyboardType: TextInputType.number,
                        isSubmitted: false,
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
          ),
        ),
      ),
    );
  }

  _showAddress(BuildContext context) {
    final addressesBloc = BlocProvider.of<AddressesBloc>(context);
    final state = addressesBloc.state;

    if (state is AddressesLoaded) {
      final addresses = state.addresses.data ?? [];
      _openAddressList(context, addresses);
    } else if (state is AddressesLoading) {
      _shouldOpenAddressList = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка адресов...')));
    } else if (state is AddressesError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: ${state.message}')));
    } else if (state is AddressesInitial) {
      _shouldOpenAddressList = true;
      addressesBloc.add(const LoadAddressesEvent());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка адресов...')));
    }
  }

  void _openAddressList(BuildContext context, List<AddressData> addresses) {
    if (addresses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Нет доступных адресов')));
      return;
    }

    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: _AddressesSelectionWidget(
        addresses: addresses,
        selectedAddress: selectedAddress,
        onSelect: (address) {
          setState(() {
            selectedAddress = address;
          });
        },
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

  _showPerformer() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedPerformer = value;
          });
        },
        isSelected: true,
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
              AppStrings.createdAppSuccess,
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

// Виджет выбора адресов из API
class _AddressesSelectionWidget extends StatelessWidget {
  final List<AddressData> addresses;
  final String? selectedAddress;
  final Function(String) onSelect;

  const _AddressesSelectionWidget({
    required this.addresses,
    required this.selectedAddress,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectAddress),
          const SizedBox(height: 20),
          Flexible(
            child: addresses.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Нет доступных адресов'),
                    ),
                  )
                : ListView.separated(
                    itemCount: addresses.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final addressText = address.address ?? '';
                      final isSelected = selectedAddress == addressText;

                      return InkWell(
                        onTap: () {
                          onSelect(addressText);
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 2,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  addressText,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
          ),
        ],
      ),
    );
  }
}
