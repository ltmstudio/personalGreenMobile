import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/utils/time_format.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/data/models/tickets/create_ticket_request_model.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_event.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_state.dart';
import 'package:hub_dom/presentation/bloc/dictionaries/dictionaries_bloc.dart';
import 'package:hub_dom/presentation/bloc/tickets/tickets_bloc.dart';
import 'package:hub_dom/presentation/pages/applications/main_applications/components/select_time_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/bottom_sheet_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/search_btn.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateEmployeeAppPage extends StatefulWidget {
  const CreateEmployeeAppPage({super.key});

  @override
  State<CreateEmployeeAppPage> createState() => _CreateEmployeeAppPageState();
}

class _CreateEmployeeAppPageState extends State<CreateEmployeeAppPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  AddressData? selectedAddress;

  ServiceType? selectedService;
  TroubleType? selectedWorkType;
  Type? selectedUrgency;

  String? formattedTime;

  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();

  // Маска для российского номера телефона: +7 (999) 999-99-99
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  DictionariesBloc? _dictionariesBloc;
  TicketsBloc? _ticketsBloc;

  @override
  void initState() {
    super.initState();
    print('=== CREATE EMPLOYEE APP INIT STATE ===');
    selectedService = null;
    selectedWorkType = null;
    selectedUrgency = null;
    selectedDate = null;
    selectedTime = null;
    selectedAddress = null;
    formattedTime = null;
    print('=== INIT STATE COMPLETED ===');
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            _dictionariesBloc = locator<DictionariesBloc>()
              ..add(const LoadDictionariesEvent());
            return _dictionariesBloc!;
          },
        ),
        BlocProvider(
          create: (context) {
            _ticketsBloc = locator<TicketsBloc>();
            return _ticketsBloc!;
          },
        ),
        BlocProvider(
          create: (context) {
            print('=== CREATING ADDRESSES BLOC ===');
            final bloc = locator<AddressesBloc>();
            print('AddressesBloc created: $bloc');
            bloc.add(const LoadAddressesEvent());
            print('LoadAddressesEvent added');
            return bloc;
          },
        ),
      ],
      child: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state is TicketCreated) {
            _showSuccessSnackBar('Тикет успешно создан!');
            // Можно добавить навигацию назад или очистку формы
            Navigator.of(context).pop();
          } else if (state is TicketCreationError) {
            _showErrorSnackBar('Ошибка создания тикета: ${state.message}');
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(AppStrings.createApplication)),
          body: BlocBuilder<DictionariesBloc, DictionariesState>(
            builder: (context, state) {
              return SingleChildScrollView(
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
                        child: Builder(
                          builder: (builderContext) {
                            return SelectBtn(
                              title: AppStrings.selectAddress,
                              value: selectedAddress?.address,
                              icon: Icon(Icons.keyboard_arrow_down),
                              showBorder: true,
                              onTap: () => _showAddress(builderContext),
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
                          value: selectedService?.title,
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
                          value: selectedWorkType?.title,
                          icon: Icon(Icons.keyboard_arrow_down),
                          showBorder: true,
                          onTap: selectedService != null
                              ? _showWorkType
                              : () {},
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
                          value: selectedUrgency?.title,
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
                          keyboardType: TextInputType.phone,
                          hintText: '+7 (___) ___-__-__',
                          borderColor: AppColors.lightGrayBorder,
                          filled: true,
                          inputFormatters: [_phoneMaskFormatter],
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
                      child: BlocBuilder<TicketsBloc, TicketsState>(
                        builder: (context, state) {
                          final isLoading = state is TicketsCreating;
                          return MainButton(
                            buttonTile: AppStrings.createNewApplication,
                            onPressed: _validateAndCreateTicket,
                            isLoading: isLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Валидация и создание тикета
  void _validateAndCreateTicket() {
    // Валидация обязательных полей
    if (selectedAddress == null) {
      _showErrorSnackBar('Выберите адрес');
      return;
    }

    if (selectedService == null) {
      _showErrorSnackBar('Выберите услугу');
      return;
    }

    if (selectedWorkType == null) {
      _showErrorSnackBar('Выберите тип работы');
      return;
    }

    if (selectedUrgency == null) {
      _showErrorSnackBar('Выберите категорию срочности');
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      _showErrorSnackBar('Выберите дату и время выполнения');
      return;
    }

    // Проверяем, что номер телефона полностью заполнен (18 символов с маской)
    if (_phoneCtrl.text.trim().isEmpty) {
      _showErrorSnackBar('Введите дополнительный номер телефона');
      return;
    }

    // Проверяем, что номер полностью введён (без учёта +7, скобок и дефисов остаётся 10 цифр)
    final unmaskedPhone = _phoneMaskFormatter.getUnmaskedText();
    if (unmaskedPhone.length < 10) {
      _showErrorSnackBar('Введите полный номер телефона');
      return;
    }

    if (_commentCtrl.text.trim().isEmpty) {
      _showErrorSnackBar('Введите комментарий');
      return;
    }

    // Создаем тикет
    _createTicket();
  }

  /// Создание тикета
  void _createTicket() {
    if (_ticketsBloc == null) return;

    // Формируем дату выполнения в нужном формате
    final deadlineDate = selectedDate!;
    final deadlineFormatted =
        '${deadlineDate.year}-${deadlineDate.month.toString().padLeft(2, '0')}-${deadlineDate.day.toString().padLeft(2, '0')}';

    // Формируем дату и время визита
    final visitingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    final visitingFormatted =
        '${visitingDateTime.year}-${visitingDateTime.month.toString().padLeft(2, '0')}-${visitingDateTime.day.toString().padLeft(2, '0')} ${visitingDateTime.hour.toString().padLeft(2, '0')}:${visitingDateTime.minute.toString().padLeft(2, '0')}:${visitingDateTime.second.toString().padLeft(2, '0')}';

    // Получаем номер телефона без форматирования
    // Удаляем все символы кроме цифр и префикса +7
    final unmaskedPhone = _phoneMaskFormatter.getUnmaskedText();
    final formattedPhone = '+7$unmaskedPhone';

    // Создаем запрос
    final request = CreateTicketRequestModel(
      objectId: selectedAddress!.id!,
      objectType: selectedAddress!.type == AddressType.house
          ? 'house'
          : 'space',
      serviceTypeId: selectedService!.id!,
      troubleTypeId: selectedWorkType!.id!,
      priorityTypeId: selectedUrgency!.id!,
      deadlinedAt: deadlineFormatted,
      visitingAt: visitingFormatted,
      additionalContact: formattedPhone,
      isEmergency: 0, // Обычная заявка
      comment: _commentCtrl.text.trim(),
      photos: null, // Пока без фотографий
    );

    // Отправляем событие создания тикета
    _ticketsBloc!.add(CreateTicketEvent(request));
  }

  /// Показать ошибку
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  /// Показать успех
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  _showAddress(BuildContext context) {
    print('=== DEBUG SHOW ADDRESS CALLED ===');

    // Получаем AddressesBloc из контекста
    final addressesBloc = BlocProvider.of<AddressesBloc>(context);
    print('AddressesBloc: $addressesBloc');

    final state = addressesBloc.state;
    print('Current state: $state');
    print('State type: ${state.runtimeType}');

    if (state is AddressesLoaded) {
      final addresses = state.addresses.data ?? [];
      print('Addresses loaded: ${addresses.length}');

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
    } else if (state is AddressesLoading) {
      print('Addresses are loading...');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка адресов...')));
    } else if (state is AddressesError) {
      print('Addresses error: ${state.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: ${state.message}')));
    } else if (state is AddressesInitial) {
      print('Addresses initial state - triggering load');
      addressesBloc.add(const LoadAddressesEvent());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка адресов...')));
    } else {
      print('Unknown state: $state');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Неизвестное состояние')));
    }
  }

  _showService() {
    if (_dictionariesBloc == null) return;
    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      final serviceTypes = state.dictionaries.serviceTypes ?? [];

      // Отладочная информация
      print('=== DEBUG SERVICE TYPES ===');
      print('Service types count: ${serviceTypes.length}');
      for (int i = 0; i < serviceTypes.length; i++) {
        final service = serviceTypes[i];
        print('Service $i: ${service.title} (ID: ${service.id})');
        print('  Trouble types count: ${service.troubleTypes?.length ?? 0}');
        if (service.troubleTypes != null && service.troubleTypes!.isNotEmpty) {
          for (int j = 0; j < service.troubleTypes!.length; j++) {
            print(
              '    Trouble $j: ${service.troubleTypes![j].title} (ID: ${service.troubleTypes![j].id})',
            );
          }
        }
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: true,
        child: _ServiceTypesSelectionWidget(
          serviceTypes: serviceTypes,
          selectedServiceType: selectedService,
          onSelect: (serviceType) {
            setState(() {
              selectedService = serviceType;
              selectedWorkType = null; // Сбрасываем выбранный тип проблемы
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  _showWorkType() {
    if (selectedService == null) {
      _showErrorSnackBar('Сначала выберите услугу');
      return;
    }
    if (_dictionariesBloc == null) return;

    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      // Получаем troubleTypes для выбранной услуги
      // Сначала пробуем из вложенного списка в service
      var troubleTypes = selectedService!.troubleTypes ?? [];

      // Если список пустой, фильтруем общий список по service_type_id
      if (troubleTypes.isEmpty) {
        final allTroubleTypes = state.dictionaries.troubleTypes ?? [];
        troubleTypes = allTroubleTypes
            .where((tt) => tt.serviceTypeId == selectedService!.id)
            .toList();
      }

      // Отладочная информация
      print('=== DEBUG WORK TYPE ===');
      print(
        'Selected service: ${selectedService!.title} (ID: ${selectedService!.id})',
      );
      print(
        'Service trouble types count: ${selectedService!.troubleTypes?.length ?? 0}',
      );
      print(
        'General trouble types count: ${state.dictionaries.troubleTypes?.length ?? 0}',
      );
      print('Filtered trouble types count: ${troubleTypes.length}');
      for (int i = 0; i < troubleTypes.length; i++) {
        print(
          'Trouble type $i: ${troubleTypes[i].title} (ID: ${troubleTypes[i].id}, ServiceTypeId: ${troubleTypes[i].serviceTypeId})',
        );
      }

      if (troubleTypes.isEmpty) {
        _showErrorSnackBar('Для выбранной услуги нет доступных типов работ');
        return;
      }

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _TroubleTypesSelectionWidget(
          troubleTypes: troubleTypes,
          selectedTroubleType: selectedWorkType,
          onSelect: (troubleType) {
            setState(() {
              selectedWorkType = troubleType;
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
  }

  _showUrgency() {
    if (_dictionariesBloc == null) return;
    final state = _dictionariesBloc!.state;

    if (state is DictionariesLoaded) {
      final priorityTypes = state.dictionaries.priorityTypes ?? [];

      bottomSheetWidget(
        context: context,
        isScrollControlled: false,
        child: _PriorityTypesSelectionWidget(
          priorityTypes: priorityTypes,
          selectedPriorityType: selectedUrgency,
          onSelect: (priorityType) {
            setState(() {
              selectedUrgency = priorityType;
            });
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Загрузка справочников...')));
    }
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
}

// Виджет выбора типов услуг
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
          BottomSheetTitle(
            title: AppStrings.selectService,
            onClear: () => onSelect(serviceTypes.first),
          ),
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
                    context.pop();
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

// Виджет выбора типов проблем
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
          BottomSheetTitle(
            title: AppStrings.selectWorkType,
            onClear: troubleTypes.isNotEmpty
                ? () => onSelect(troubleTypes.first)
                : null,
          ),
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
                          context.pop();
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

// Виджет выбора типов приоритета
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
          BottomSheetTitle(
            title: AppStrings.selectCategoryType,
            onClear: () => onSelect(priorityTypes.first),
          ),
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
                    context.pop();
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

// Виджет выбора адресов
class _AddressesSelectionWidget extends StatelessWidget {
  final List<AddressData> addresses;
  final AddressData? selectedAddress;
  final Function(AddressData) onSelect;

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
          BottomSheetTitle(
            title: AppStrings.selectAddress,
            onClear: addresses.isNotEmpty
                ? () => onSelect(addresses.first)
                : null,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: addresses.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Нет доступных адресов'),
                    ),
                  )
                : ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isSelected = selectedAddress?.id == address.id;

                      return ListTile(
                        title: Text(address.address ?? ''),
                        subtitle: Text('ID: ${address.id}'),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onSelect(address);
                          context.pop();
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
