// report_models.dart

class TicketReport {
  final int id;
  final String comment;
  final String type;
  final ReportUser createdBy;
  final String createdAt; // API gives already formatted "19.11.2025 12:50"

  const TicketReport({
    required this.id,
    required this.comment,
    required this.type,
    required this.createdBy,
    required this.createdAt,
  });

  factory TicketReport.fromJson(Map<String, dynamic> json) {
    return TicketReport(
      id: (json['id'] as num).toInt(),
      comment: (json['comment'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      createdBy: ReportUser.fromJson((json['created_by'] ?? {}) as Map<String, dynamic>),
      createdAt: (json['created_at'] ?? '').toString(),
    );
  }
}

class ReportUser {
  final int id;
  final String fullName;

  const ReportUser({
    required this.id,
    required this.fullName,
  });

  factory ReportUser.fromJson(Map<String, dynamic> json) {
    return ReportUser(
      id: ((json['id'] ?? 0) as num).toInt(),
      fullName: (json['full_name'] ?? '').toString(),
    );
  }
}

/// If you want to parse only the "data" array fast:
List<TicketReport> parseReportsData(Map<String, dynamic> rootJson) {
  final raw = (rootJson['data'] as List? ?? const []);
  return raw
      .whereType<Map<String, dynamic>>()
      .map(TicketReport.fromJson)
      .toList();
}
