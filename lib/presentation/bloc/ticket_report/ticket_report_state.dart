// reports_state.dart
part of 'ticket_report_cubit.dart';


enum ReportsStatus { initial, loading, success, failure }

class ReportsState extends Equatable {
  final ReportsStatus status;
  final List<TicketReport> items;
  final String? error;

  const ReportsState({
    required this.status,
    required this.items,
    required this.error,
  });

  const ReportsState.initial()
      : status = ReportsStatus.initial,
        items = const [],
        error = null;

  ReportsState copyWith({
    ReportsStatus? status,
    List<TicketReport>? items,
    String? error,
  }) {
    return ReportsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
