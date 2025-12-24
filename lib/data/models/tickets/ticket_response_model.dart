// To parse this JSON data, do
//
//     final ticketResponseModel = ticketResponseModelFromJson(jsonString);

import 'dart:convert';

TicketResponseModel ticketResponseModelFromJson(String str) =>
    TicketResponseModel.fromJson(json.decode(str));

String ticketResponseModelToJson(TicketResponseModel data) =>
    json.encode(data.toJson());

class TicketResponseModel {
  final List<Ticket>? tickets;
  final List<Stat>? stats;

  TicketResponseModel({this.tickets, this.stats});

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) =>
      TicketResponseModel(
        tickets: json["data"] == null
            ? []
            : List<Ticket>.from(
                json["data"]!.map((x) => Ticket.fromJson(x)),
              ),
        stats: json["stats"] == null
            ? []
            : List<Stat>.from(json["stats"]!.map((x) => Stat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": tickets == null
        ? []
        : List<dynamic>.from(tickets!.map((x) => x.toJson())),
    "stats": stats == null
        ? []
        : List<dynamic>.from(stats!.map((x) => x.toJson())),
  };
}
class ToggleWorkUnitItem {
  final int id;
  final bool checked;

  ToggleWorkUnitItem({required this.id, required this.checked});

  Map<String, dynamic> toJson() => {
    "id": id,
    "checked": checked,
  };
}

class ToggleWorkUnitsRequest {
  final List<ToggleWorkUnitItem> workUnits;

  ToggleWorkUnitsRequest({required this.workUnits});

  Map<String, dynamic> toJson() => {
    "work_units": workUnits.map((e) => e.toJson()).toList(),
  };
}

class Stat {
  final int? id;
  final int? count;
  final String? name;
  final String? title;

  Stat({this.id, this.count, this.name, this.title});

  factory Stat.fromJson(Map<String, dynamic> json) =>
      Stat(
        id: json["id"],
        count: json["count"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "count": count,
    "name": name,
    "title": title,
  };
}

class Ticket {
  final int? id;
  final TicketStatus? status;
  final DateTime? visitingAt;
  final TicketType? serviceType;
  final TicketType? troubleType;
  final int? executorId;
  final Executor? executor;
  final TicketPriorityType? priorityType;
  final String? comment;
  final int? objectId;
  final String? address;
  final DateTime? createdAt;
  final DateTime? deadlinedAt;

  Ticket({
    this.id,
    this.status,
    this.visitingAt,
    this.serviceType,
    this.troubleType,
    this.executorId,
    this.executor,
    this.priorityType,
    this.comment,
    this.objectId,
    this.address,
    this.createdAt,
    this.deadlinedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    status: json["status"] == null
        ? null
        : TicketStatus.fromJson(json["status"]),
    visitingAt: json["visiting_at"] == null
        ? null
        : DateTime.parse(json["visiting_at"]),
    serviceType: json["service_type"] == null
        ? null
        : TicketType.fromJson(json["service_type"]),
    troubleType: json["trouble_type"] == null
        ? null
        : TicketType.fromJson(json["trouble_type"]),
    executorId: json["executor_id"],
    executor: json["executor"] == null
        ? null
        : Executor.fromJson(json["executor"]),
    priorityType: json["priority_type"] == null
        ? null
        : TicketPriorityType.fromJson(json["priority_type"]),
    comment: json["comment"],
    objectId: json["object_id"],
    address: json["address"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    deadlinedAt: json["deadlined_at"] == null
        ? null
        : DateTime.parse(json["deadlined_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status?.toJson(),
    "visiting_at": visitingAt?.toIso8601String(),
    "service_type": serviceType?.toJson(),
    "trouble_type": troubleType?.toJson(),
    "executor_id": executorId,
    "executor": executor?.toJson(),
    "priority_type": priorityType?.toJson(),
    "comment": comment,
    "object_id": objectId,
    "address": address,
    "created_at": createdAt?.toIso8601String(),
    "deadlined_at": deadlinedAt?.toIso8601String(),
  };
}

class Executor {
  final int? id;
  final String? name;
  final String? lastname;
  final String? surname;
  final String? email;
  final dynamic phone;
  final String? _fullNameFromJson;

  Executor({
    this.id,
    this.name,
    this.lastname,
    this.surname,
    this.email,
    this.phone,
    String? fullName,
  }) : _fullNameFromJson = fullName;

  factory Executor.fromJson(Map<String, dynamic> json) => Executor(
    id: json["id"],
    name: json["name"],
    lastname: json["lastname"],
    surname: json["surname"],
    email: json["email"],
    phone: json["phone"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "surname": surname,
    "email": email,
    "phone": phone,
    "full_name": _fullNameFromJson,
  };

  String get fullName {
    // Если есть готовое поле full_name из JSON, используем его
    final fullNameFromJson = _fullNameFromJson;
    if (fullNameFromJson != null && fullNameFromJson.isNotEmpty) {
      return fullNameFromJson;
    }
    // Иначе собираем из отдельных полей
    final parts = [
      lastname,
      name,
      surname,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.isEmpty ? 'Не указано' : parts.join(' ');
  }
}

class TicketPriorityType {
  final int? id;
  final String? title;
  final String? name;
  final String? color;

  TicketPriorityType({this.id, this.title, this.name, this.color});

  factory TicketPriorityType.fromJson(Map<String, dynamic> json) =>
      TicketPriorityType(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
    "color": color,
  };
}

class TicketType {
  final int? id;
  final String? title;

  TicketType({this.id, this.title});

  factory TicketType.fromJson(Map<String, dynamic> json) =>
      TicketType(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}

class TicketStatus {
  final int? id;
  final String? title;
  final String? name;
  final String? color;
  final String? fontColor;

  TicketStatus({this.id, this.title, this.name, this.color, this.fontColor});

  factory TicketStatus.fromJson(Map<String, dynamic> json) => TicketStatus(
    id: json["id"],
    title: json["title"],
    name: json["name"],
    color: json["color"],
    fontColor: json["font_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
    "color": color,
    "font_color": fontColor,
  };
}
