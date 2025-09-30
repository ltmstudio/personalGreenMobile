part of 'crm_system_cubit.dart';

sealed class CrmSystemState {}

final class CrmSystemInitial extends CrmSystemState {}
final class CrmSystemLoading extends CrmSystemState {}
final class CrmSystemLoaded extends CrmSystemState {
  final List<CrmSystemModel> data;

  CrmSystemLoaded(this.data);
}
final class CrmSystemError extends CrmSystemState {}
final class CrmSystemConnectionError extends CrmSystemState {}
