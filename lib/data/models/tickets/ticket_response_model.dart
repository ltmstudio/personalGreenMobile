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
        tickets: json["tickets"] == null
            ? []
            : List<Ticket>.from(
                json["tickets"]!.map((x) => Ticket.fromJson(x)),
              ),
        stats: json["stats"] == null
            ? []
            : List<Stat>.from(json["stats"]!.map((x) => Stat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "tickets": tickets == null
        ? []
        : List<dynamic>.from(tickets!.map((x) => x.toJson())),
    "stats": stats == null
        ? []
        : List<dynamic>.from(stats!.map((x) => x.toJson())),
  };
}

class Stat {
  final int? id;
  final int? count;
  final String? name;

  Stat({this.id, this.count, this.name});

  factory Stat.fromJson(Map<String, dynamic> json) =>
      Stat(id: json["id"], count: json["count"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "count": count, "name": name};
}

class Ticket {
  final int? id;
  final TicketStatus? status;
  final DateTime? visitingAt;
  final TicketType? serviceType;
  final TicketType? troubleType;
  final Executor? executor;
  final TicketPriorityType? priorityType;
  final String? comment;
  final String? address;
  final DateTime? createdAt;
  final DateTime? deadlinedAt;

  Ticket({
    this.id,
    this.status,
    this.visitingAt,
    this.serviceType,
    this.troubleType,
    this.executor,
    this.priorityType,
    this.comment,
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
    executor: json["executor"] == null
        ? null
        : Executor.fromJson(json["executor"]),
    priorityType: json["priority_type"] == null
        ? null
        : TicketPriorityType.fromJson(json["priority_type"]),
    comment: json["comment"],
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
    "executor": executor?.toJson(),
    "priority_type": priorityType?.toJson(),
    "comment": comment,
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

  Executor({
    this.id,
    this.name,
    this.lastname,
    this.surname,
    this.email,
    this.phone,
  });

  factory Executor.fromJson(Map<String, dynamic> json) => Executor(
    id: json["id"],
    name: json["name"],
    lastname: json["lastname"],
    surname: json["surname"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "surname": surname,
    "email": email,
    "phone": phone,
  };

  String get fullName {
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

  TicketStatus({this.id, this.title, this.name, this.color});

  factory TicketStatus.fromJson(Map<String, dynamic> json) => TicketStatus(
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
