import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/data/models/tickets/dictionary_model.dart';
import 'package:hub_dom/presentation/bloc/work_units/work_units_bloc.dart';

class WorkUnitsWidget extends StatelessWidget {
  final List<WorkUnit> workUnits;

  const WorkUnitsWidget({
    super.key,
    required this.workUnits,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = WorkUnitsBloc();
        bloc.add(LoadWorkUnitsEvent(workUnits: workUnits));
        return bloc;
      },
      child: BlocBuilder<WorkUnitsBloc, WorkUnitsState>(
        builder: (context, state) {
          if (state is WorkUnitsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WorkUnitsError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray,
                    ),
              ),
            );
          }

          if (state is WorkUnitsLoaded) {
            if (state.workUnits.isEmpty) {
              return Center(
                child: Text(
                  'Нет доступных работ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray,
                      ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.workUnits.length,
              itemBuilder: (context, index) {
                final workUnit = state.workUnits[index];
                final isSelected = state.selectedIds.contains(workUnit.id);

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
                              workUnit.title ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              if (workUnit.id != null) {
                                context.read<WorkUnitsBloc>().add(
                                      ToggleWorkUnitEvent(
                                        workUnitId: workUnit.id!,
                                      ),
                                    );
                              }
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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

