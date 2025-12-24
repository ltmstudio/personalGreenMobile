import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/data/models/tickets/get_ticket_response_model.dart';
import 'package:hub_dom/locator.dart';
import 'package:hub_dom/presentation/bloc/work_unit_toggle/work_unit_toggle_cubit.dart';

class ChecklistWidget extends StatefulWidget {
  const ChecklistWidget({super.key, required this.ticketData});
  final Data ticketData;

  @override
  State<ChecklistWidget> createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  late final List<WorkUnit> tasks;

  int? selectedId;

  @override
  void initState() {
    super.initState();
    tasks = List<WorkUnit>.from(widget.ticketData.workUnits);

  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final item = tasks[index];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Number
            Text(
              "${index + 1}. ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Expanded text + checkbox
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.title?? 'Данных нет',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Checkbox(

                    value: item.checked ,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        tasks[index] = tasks[index].copyWith(checked: val);
                      });
                      locator<WorkUnitsCubit>().toggleOne(
                        ticketId: widget.ticketData.id!,
                        workUnitId: item.id,
                        checked: val,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: AppColors.timeColor,
                    checkColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
