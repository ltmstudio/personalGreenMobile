import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/time_format.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/data/models/employees/get_employee_response_model.dart';
import 'package:hub_dom/core/usecase/tickets/create_ticket_params.dart';
import 'package:hub_dom/core/utils/formatters/ticket_formatter.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/performer_widget.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/select_time_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/gray_loading_indicator.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';

class CreateApplicationPage extends StatefulWidget {
  const CreateApplicationPage({super.key});

  @override
  State<CreateApplicationPage> createState() => _CreateApplicationPageState();
}

class _CreateApplicationPageState extends State<CreateApplicationPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? selectedAddress;
  AddressData? _selectedAddressData; // Сохраняем объект адреса для получения ID

  String? selectedService; // Название услуги для отображения
  ServiceType? _selectedServiceData; // Объект услуги для получения ID
  String? selectedWorkType; // Название типа работы для отображения
  TroubleType? _selectedWorkTypeData; // Объект типа работы для получения ID
  String? selectedPerformer;
  Employee? _selectedEmployeeData; // Объект исполнителя для получения ID
  String? selectedUrgency; // Название приоритета для отображения
  Type? _selectedUrgencyData; // Объект приоритета для получения ID

  String? formattedTime;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addPhoneCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();

  // Маска для российского номера телефона: +7 (999) 999-99-99
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Состояние ошибок валидации
  bool _hasCommentError = false;
  bool _hasPhoneError = false;

  bool _shouldOpenAddressList = false;
  List<File> _selectedPhotos = []; // Список выбранных фотографий

  @override
  void initState() {
    super.initState();
    selectedService = null;
    selectedWorkType = null;
    selectedPerformer = null;
    _selectedEmployeeData = null;
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
        BlocProvider(
          create: (context) {
            final bloc = locator<DictionariesBloc>()
              ..add(const LoadDictionariesEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) {
            return locator<TicketsBloc>();
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
          child: BlocListener<TicketsBloc, TicketsState>(
            listener: (context, state) {
              if (state is TicketCreated) {
                _showSuccess();
                // Очищаем форму после успешного создания
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    context.pop();
                  }
                });
              } else if (state is TicketCreationError) {
                // Обрабатываем ошибки валидации от сервера
                _handleValidationErrors(state.message);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка создания заявки: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
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
                                  ? const GrayLoadingIndicator(size: 20)
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
                          onTap: () => _showService(context),
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

                          onTap: () => _showWorkType(context),
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

                          onTap: () => _showUrgency(context),
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

                          onTap: () => _showTime(context),
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

                          onTap: () => _showPerformer(context),
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
                          keyboardType: TextInputType.phone,
                          isSubmitted: false,
                          hintText: '+7 (___) ___-__-__',
                          borderColor: _hasPhoneError
                              ? AppColors.red
                              : AppColors.lightGrayBorder,
                          filled: true,
                          inputFormatters: [_phoneMaskFormatter],
                          onChange: (value) {
                            if (_hasPhoneError) {
                              setState(() {
                                _hasPhoneError = false;
                              });
                            }
                          },
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
                          borderColor: _hasCommentError
                              ? AppColors.red
                              : AppColors.lightGrayBorder,
                          filled: true,
                          maxLines: 3,
                          onChange: (value) {
                            if (_hasCommentError) {
                              setState(() {
                                _hasCommentError = false;
                              });
                            }
                          },
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
                    MultiImagePickerWidget(
                      onImagesChanged: (List<XFile> images) {
                        setState(() {
                          _selectedPhotos = images
                              .map((xFile) => File(xFile.path))
                              .toList();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: BlocBuilder<TicketsBloc, TicketsState>(
                        builder: (context, state) {
                          final isLoading = state is TicketsCreating;
                          return MainButton(
                            buttonTile: AppStrings.createNewApplication,
                            onPressed: () => _validateAndCreateTicket(context),
                            isLoading: isLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
        onSelect: (address, addressData) {
          setState(() {
            selectedAddress = address;
            _selectedAddressData = addressData;
          });
        },
      ),
    );
  }

  void _showService(BuildContext context) {
    final dictionariesBloc = context.read<DictionariesBloc>();
    final state = dictionariesBloc.state;

    if (state is DictionariesLoaded) {
      final serviceTypes = state.dictionaries.serviceTypes ?? [];

      if (serviceTypes.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Нет доступных услуг')));
        return;
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: true,
        child: _ServiceTypesSelectionWidget(
          serviceTypes: serviceTypes,
          selectedServiceType: _selectedServiceData,
          onSelect: (serviceType) {
            setState(() {
              selectedService = serviceType.title;
              _selectedServiceData = serviceType;
              selectedWorkType = null; // Сбрасываем выбранный тип работы
              _selectedWorkTypeData = null;
            });
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  void _showWorkType(BuildContext context) {
    if (_selectedServiceData == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Сначала выберите услугу')));
      return;
    }

    final dictionariesBloc = context.read<DictionariesBloc>();
    final state = dictionariesBloc.state;

    if (state is DictionariesLoaded) {
      // Получаем troubleTypes для выбранной услуги
      var troubleTypes = _selectedServiceData!.troubleTypes ?? [];

      // Если список пустой, фильтруем общий список по service_type_id
      if (troubleTypes.isEmpty) {
        final allTroubleTypes = state.dictionaries.troubleTypes ?? [];
        troubleTypes = allTroubleTypes
            .where((tt) => tt.serviceTypeId == _selectedServiceData!.id)
            .toList();
      }

      if (troubleTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Для выбранной услуги нет доступных типов работ'),
          ),
        );
        return;
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _TroubleTypesSelectionWidget(
          troubleTypes: troubleTypes,
          selectedTroubleType: _selectedWorkTypeData,
          onSelect: (troubleType) {
            setState(() {
              selectedWorkType = troubleType.title;
              _selectedWorkTypeData = troubleType;
            });
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  void _showUrgency(BuildContext context) {
    final dictionariesBloc = context.read<DictionariesBloc>();
    final state = dictionariesBloc.state;

    if (state is DictionariesLoaded) {
      final priorityTypes = state.dictionaries.priorityTypes ?? [];

      if (priorityTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет доступных категорий срочности')),
        );
        return;
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _PriorityTypesSelectionWidget(
          priorityTypes: priorityTypes,
          selectedPriorityType: _selectedUrgencyData,
          onSelect: (priorityType) {
            setState(() {
              selectedUrgency = priorityType.title;
              _selectedUrgencyData = priorityType;
            });
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  void _showTime(BuildContext context) {
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

  void _showPerformer(BuildContext context) {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: PerformerWidget(
        onSelectItem: (String value) {
          setState(() {
            selectedPerformer = value;
          });
        },
        onSelectEmployee: (employee) {
          setState(() {
            selectedPerformer = employee.fullName ?? '';
            _selectedEmployeeData = employee; // Сохраняем объект исполнителя
          });
          // PerformerWidget сам закрывает bottom sheet через Navigator.pop()
        },
        isSelected: true,
      ),
    );
  }

  /// Обработка ошибок валидации от сервера
  void _handleValidationErrors(String errorMessage) {
    setState(() {
      _hasCommentError = false;
      _hasPhoneError = false;
    });

    // Проверяем наличие ошибок в сообщении (регистронезависимый поиск)
    final lowerMessage = errorMessage.toLowerCase();
    if (lowerMessage.contains('comment') ||
        lowerMessage.contains('комментарий') ||
        lowerMessage.contains('поле comment обязательно')) {
      setState(() {
        _hasCommentError = true;
      });
    }
    if (lowerMessage.contains('phone') ||
        lowerMessage.contains('телефон') ||
        lowerMessage.contains('additional_contact') ||
        lowerMessage.contains('phone field format')) {
      setState(() {
        _hasPhoneError = true;
      });
    }
  }

  /// Валидация и создание заявки
  void _validateAndCreateTicket(BuildContext context) {
    // Сбрасываем ошибки
    setState(() {
      _hasCommentError = false;
      _hasPhoneError = false;
    });

    if (_selectedAddressData == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите адрес')));
      return;
    }

    if (selectedService == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите услугу')));
      return;
    }

    if (selectedWorkType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите тип работы')));
      return;
    }

    if (selectedUrgency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите категорию срочности')),
      );
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите дату и время')));
      return;
    }

    // Валидация комментария (обязательное поле)
    if (_commentCtrl.text.trim().isEmpty) {
      setState(() {
        _hasCommentError = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите комментарий')));
      return;
    }

    // Валидация телефона
    final unmaskedPhone = _phoneMaskFormatter.getUnmaskedText();
    if (unmaskedPhone.length < 10) {
      setState(() {
        _hasPhoneError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите полный номер телефона')),
      );
      return;
    }

    // Получаем блоки из контекста
    final dictionariesBloc = context.read<DictionariesBloc>();
    final ticketsBloc = context.read<TicketsBloc>();

    final dictionariesState = dictionariesBloc.state;
    if (dictionariesState is! DictionariesLoaded) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
      return;
    }

    _createTicket(dictionariesState, ticketsBloc, context);
  }

  /// Создание заявки через API
  void _createTicket(
    DictionariesLoaded dictionariesState,
    TicketsBloc ticketsBloc,
    BuildContext context,
  ) {
    // Используем сохраненные объекты из справочников
    if (_selectedServiceData == null || _selectedServiceData!.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Не выбрана услуга')));
      return;
    }

    if (_selectedWorkTypeData == null || _selectedWorkTypeData!.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Не выбран тип работы')));
      return;
    }

    if (_selectedUrgencyData == null || _selectedUrgencyData!.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не выбрана категория срочности')),
      );
      return;
    }

    final serviceType = _selectedServiceData!;
    final troubleType = _selectedWorkTypeData!;
    final priorityType = _selectedUrgencyData!;

    // Формируем дату выполнения
    final deadlineDate = selectedDate!;

    // Формируем дату и время визита
    final visitingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Форматируем телефон - получаем только цифры из маски
    final formattedPhone = TicketFormatter.formatPhone(
      _addPhoneCtrl.text,
      _phoneMaskFormatter,
    );

    // Создаем параметры для UseCase
    final params = CreateTicketParams(
      objectId: _selectedAddressData!.id!,
      objectType: _selectedAddressData!.type == AddressType.house
          ? 'house'
          : 'space',
      serviceTypeId: serviceType.id!,
      troubleTypeId: troubleType.id!,
      priorityTypeId: priorityType.id!,
      deadlineDate: deadlineDate,
      visitingDateTime: visitingDateTime,
      comment: _commentCtrl.text.trim(),
      additionalContact: formattedPhone.isNotEmpty ? formattedPhone : null,
      isEmergency: 0,
      photos: _selectedPhotos.isNotEmpty ? _selectedPhotos : null,
      executorId: _selectedEmployeeData?.id,
    );

    // Отправляем событие создания заявки
    ticketsBloc.add(CreateTicketEvent(params));
  }

  _showSuccess() {
    bottomSheetWidget(
      context: context,
      isScrollControlled: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomSheetTitle(title: AppStrings.selectPerformer),
            SizedBox(height: 60),
            SvgPicture.asset(IconAssets.success, height: 140, width: 140),
            SizedBox(height: 60),
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
  final Function(String, AddressData) onSelect;

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
                          onSelect(addressText, address);
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

// Виджет выбора типов услуг из справочников
class _ServiceTypesSelectionWidget extends StatelessWidget {
  final List<ServiceType> serviceTypes;
  final ServiceType? selectedServiceType;
  final Function(ServiceType) onSelect;

  const _ServiceTypesSelectionWidget({
    required this.serviceTypes,
    required this.selectedServiceType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectService),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: serviceTypes.length,
              itemBuilder: (context, index) {
                final serviceType = serviceTypes[index];
                final isSelected = selectedServiceType?.id == serviceType.id;

                return ListTile(
                  title: Text(serviceType.title ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onSelect(serviceType);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Виджет выбора типов проблем из справочников
class _TroubleTypesSelectionWidget extends StatelessWidget {
  final List<TroubleType> troubleTypes;
  final TroubleType? selectedTroubleType;
  final Function(TroubleType) onSelect;

  const _TroubleTypesSelectionWidget({
    required this.troubleTypes,
    required this.selectedTroubleType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.selectWorkType),
          const SizedBox(height: 20),
          Flexible(
            child: troubleTypes.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Нет доступных типов работ'),
                    ),
                  )
                : ListView.builder(
                    itemCount: troubleTypes.length,
                    itemBuilder: (context, index) {
                      final troubleType = troubleTypes[index];
                      final isSelected =
                          selectedTroubleType?.id == troubleType.id;

                      return ListTile(
                        title: Text(troubleType.title ?? ''),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onSelect(troubleType);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Виджет выбора типов приоритета из справочников
class _PriorityTypesSelectionWidget extends StatelessWidget {
  final List<Type> priorityTypes;
  final Type? selectedPriorityType;
  final Function(Type) onSelect;

  const _PriorityTypesSelectionWidget({
    required this.priorityTypes,
    required this.selectedPriorityType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          BottomSheetTitle(title: AppStrings.categoryType),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: priorityTypes.length,
              itemBuilder: (context, index) {
                final priorityType = priorityTypes[index];
                final isSelected = selectedPriorityType?.id == priorityType.id;

                return ListTile(
                  title: Text(priorityType.title ?? ''),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onSelect(priorityType);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
