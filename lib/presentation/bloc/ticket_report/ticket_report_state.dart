// reports_state.dart
part of 'ticket_report_cubit.dart';


enum ReportsStatus { initial, loading, success, failure }

class ReportsState extends Equatable {
  final ReportsStatus status;
  final List<TicketReport> items;
  final String? error;
  final bool isSubmitting;
  const ReportsState({
    required this.status,
    required this.items,
    required this.error,
    required this.isSubmitting,

  });

  const ReportsState.initial()
      : status = ReportsStatus.initial,
        items = const [],
        error = null,
  isSubmitting = false;


  ReportsState copyWith({
    ReportsStatus? status,
    List<TicketReport>? items,
    String? error,
    bool? isSubmitting,

  }) {
    return ReportsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,

    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
