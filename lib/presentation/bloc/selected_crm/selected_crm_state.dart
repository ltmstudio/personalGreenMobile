part of 'selected_crm_cubit.dart';

sealed class SelectedCrmState {}

final class SelectedCrmInitial extends SelectedCrmState {}

final class SelectedCrmLoaded extends SelectedCrmState {
  final CrmSystemModel data;

  SelectedCrmLoaded(this.data);
}

final class SelectedCrmLoading extends SelectedCrmState {}

final class SelectedCrmRegistered extends SelectedCrmState {}

final class SelectedCrmError extends SelectedCrmState {}

final class SelectedCrmConnectionError extends SelectedCrmState {}
