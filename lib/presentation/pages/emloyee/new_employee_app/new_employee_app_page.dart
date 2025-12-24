import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/pages/applications/application_details/components/address_card_widget.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/image_picker_widget.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/main_card.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';

class NewEmployeeAppsPage extends StatefulWidget {
  const NewEmployeeAppsPage({super.key});

  @override
  State<NewEmployeeAppsPage> createState() => _NewEmployeeAppsPageState();
}

class _NewEmployeeAppsPageState extends State<NewEmployeeAppsPage> {
  final TextEditingController _commentCtrl = TextEditingController();

  final items = [
    'Нужна замена',
    'Очень грязно',
    'Повреждено',
    'Требует внимания',
    'Критическое состояние',
  ];
  final Set<int> _selectedIndexes = {};

  int? _selected1;
  int? _selected2;
  int? _selected3;

  int? _selectedNumber;

  void _onChipTap(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index); // deselect if already selected
      } else {
        _selectedIndexes.add(index); // select new
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заявка на осмотр №123')),
      body: SingleChildScrollView(
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AddressCardWidget(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.categoryInspection,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 14),

            ///1
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MainCardWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 12),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.lightingWorks,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      CheckStatusBtn(
                        selectedIndex: _selected1,
                        onSelect: (index) {
                          setState(() {
                            _selected1 = index;
                          });
                        },
                      ),
                    ],
                  ),
                  initiallyExpanded: false,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  // optional
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.upload10Photo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),

                    MultiImagePickerWidget(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            ///2
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MainCardWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    AppStrings.pureState,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  initiallyExpanded: false,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  // optional
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(
                            5,
                            (item) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedNumber = item;
                                });
                              },
                              child: Chip(
                                label: Text('${item + 1}'),
                                backgroundColor: item == _selectedNumber
                                    ? AppColors.green
                                    : AppColors.whiteG,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: item == _selectedNumber
                                          ? AppColors.white
                                          : AppColors.primary,
                                    ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.upload10Photo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),

                    MultiImagePickerWidget(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            ///3
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MainCardWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 12),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.mailBox,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      CheckStatusBtn(
                        selectedIndex: _selected2,
                        onSelect: (index) {
                          setState(() {
                            _selected2 = index;
                          });
                        },
                      ),
                    ],
                  ),

                  initiallyExpanded: false,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  // optional
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 6,
                        runSpacing: 0,
                        children: List.generate(
                          items.length,
                          (index) => GestureDetector(
                            onTap: () => _onChipTap(index),
                            child: Chip(
                              label: Text(items[index]),
                              backgroundColor: _selectedIndexes.contains(index)
                                  ? AppColors.selectedBlue
                                  : AppColors.whiteG,
                              labelStyle: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.upload10Photo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),

                    MultiImagePickerWidget(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            ///4
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MainCardWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 12),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.mailBox,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                          maxLines: 1
                      ),

                      Row(
                        children: [
                          CheckStatusBtn(
                            selectedIndex: _selected3,
                            onSelect: (index) {
                              setState(() {
                                _selected3 = index;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  initiallyExpanded: false,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  // optional
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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

                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.upload10Photo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),

                    MultiImagePickerWidget(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: MainButton(
                buttonTile: AppStrings.inspected,
                onPressed: () {},
                isLoading: false,
              ),
            ),
          ],
        ),
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

class CheckStatusBtn extends StatelessWidget {
  final int? selectedIndex; // 0 = done, 1 = close, null = none
  final ValueChanged<int> onSelect;

  const CheckStatusBtn({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onSelect(0),
          child: CircleAvatar(
            backgroundColor: selectedIndex == 0
                ? Colors.green
                : AppColors.whiteG,
            radius: 16,
            child: Icon(
              Icons.done,
              size: 18,
              color: selectedIndex == 0 ? Colors.white : AppColors.gray,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onSelect(1),
          child: CircleAvatar(
            backgroundColor: selectedIndex == 1 ? Colors.red : AppColors.whiteG,
            radius: 16,
            child: Icon(
              Icons.close,
              size: 18,
              color: selectedIndex == 1 ? Colors.white : AppColors.gray,
            ),
          ),
        ),
      ],
    );
  }
}
