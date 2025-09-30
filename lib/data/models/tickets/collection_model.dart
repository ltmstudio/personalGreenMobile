import 'dictionary_model.dart';

class CollectionModel {
  final int id;
  final StatusModel status;
  final dynamic visitingAt;
  final EType serviceType;
  final EType troubleType;
  final PriorityType priorityType;
  final String comment;
  final String address;
  final String section;
  final DateTime createdAt;
  final DateTime deadlinedAt;

  CollectionModel({
    required this.id,
    required this.status,
    required this.visitingAt,
    required this.serviceType,
    required this.troubleType,
    required this.priorityType,
    required this.comment,
    required this.address,
    required this.section,
    required this.createdAt,
    required this.deadlinedAt,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      CollectionModel(
        id: json["id"],
        status: StatusModel.fromJson(json["status"]),
        visitingAt: json["visiting_at"],
        serviceType: EType.fromJson(json["service_type"]),
        troubleType: EType.fromJson(json["trouble_type"]),
        priorityType: PriorityType.fromJson(json["priority_type"]),
        comment: json["comment"],
        address: json["address"],
        section: json["section"],
        createdAt: DateTime.parse(json["created_at"]),
        deadlinedAt: DateTime.parse(json["deadlined_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status.toJson(),
    "visiting_at": visitingAt,
    "service_type": serviceType.toJson(),
    "trouble_type": troubleType.toJson(),
    "priority_type": priorityType.toJson(),
    "comment": comment,
    "address": address,
    "section": section,
    "created_at": createdAt.toIso8601String(),
    "deadlined_at": deadlinedAt.toIso8601String(),
  };
}

class PriorityType {
  final int? id;
  final String title;
  final String name;
  final String color;

  PriorityType({
    required this.id,
    required this.title,
    required this.name,
    required this.color,
  });

  factory PriorityType.fromJson(Map<String, dynamic> json) => PriorityType(
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

class EType {
  final int id;
  final String title;

  EType({required this.id, required this.title});

  factory EType.fromJson(Map<String, dynamic> json) =>
      EType(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
