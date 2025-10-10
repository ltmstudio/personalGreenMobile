// To parse this JSON data, do
//
//     final createTicketResponseModel = createTicketResponseModelFromJson(jsonString);

import 'dart:convert';

CreateTicketResponseModel createTicketResponseModelFromJson(String str) =>
    CreateTicketResponseModel.fromJson(json.decode(str));

String createTicketResponseModelToJson(CreateTicketResponseModel data) =>
    json.encode(data.toJson());

class CreateTicketResponseModel {
  final CreateTicketData? data;

  CreateTicketResponseModel({this.data});

  factory CreateTicketResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateTicketResponseModel(
        data: json["data"] == null
            ? null
            : CreateTicketData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class CreateTicketData {
  final int? id;
  final DateTime? visitingAt;
  final CreateTicketStatus? status;
  final CreateTicketTaxType? taxType;
  final CreateTicketTroubleType? troubleType;
  final CreateTicketPriorityType? priorityType;
  final CreateTicketObject? object;

  CreateTicketData({
    this.id,
    this.visitingAt,
    this.status,
    this.taxType,
    this.troubleType,
    this.priorityType,
    this.object,
  });

  factory CreateTicketData.fromJson(Map<String, dynamic> json) =>
      CreateTicketData(
        id: json["id"],
        visitingAt: json["visiting_at"] == null
            ? null
            : DateTime.parse(json["visiting_at"]),
        status: json["status"] == null
            ? null
            : CreateTicketStatus.fromJson(json["status"]),
        taxType: json["tax_type"] == null
            ? null
            : CreateTicketTaxType.fromJson(json["tax_type"]),
        troubleType: json["trouble_type"] == null
            ? null
            : CreateTicketTroubleType.fromJson(json["trouble_type"]),
        priorityType: json["priority_type"] == null
            ? null
            : CreateTicketPriorityType.fromJson(json["priority_type"]),
        object: json["object"] == null
            ? null
            : CreateTicketObject.fromJson(json["object"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visiting_at": visitingAt?.toIso8601String(),
    "status": status?.toJson(),
    "tax_type": taxType?.toJson(),
    "trouble_type": troubleType?.toJson(),
    "priority_type": priorityType?.toJson(),
    "object": object?.toJson(),
  };
}

class CreateTicketObject {
  final CreateTicketResidentComplex? residentComplex;

  CreateTicketObject({this.residentComplex});

  factory CreateTicketObject.fromJson(Map<String, dynamic> json) =>
      CreateTicketObject(
        residentComplex: json["resident_complex"] == null
            ? null
            : CreateTicketResidentComplex.fromJson(json["resident_complex"]),
      );

  Map<String, dynamic> toJson() => {
    "resident_complex": residentComplex?.toJson(),
  };
}

class CreateTicketResidentComplex {
  final int? id;
  final String? name;

  CreateTicketResidentComplex({this.id, this.name});

  factory CreateTicketResidentComplex.fromJson(Map<String, dynamic> json) =>
      CreateTicketResidentComplex(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class CreateTicketPriorityType {
  final int? id;
  final String? title;
  final String? name;
  final String? color;

  CreateTicketPriorityType({this.id, this.title, this.name, this.color});

  factory CreateTicketPriorityType.fromJson(Map<String, dynamic> json) =>
      CreateTicketPriorityType(
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

class CreateTicketStatus {
  final String? name;
  final String? title;
  final String? color;

  CreateTicketStatus({this.name, this.title, this.color});

  factory CreateTicketStatus.fromJson(Map<String, dynamic> json) =>
      CreateTicketStatus(
        name: json["name"],
        title: json["title"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
    "color": color,
  };
}

class CreateTicketTaxType {
  final int? id;
  final String? title;

  CreateTicketTaxType({this.id, this.title});

  factory CreateTicketTaxType.fromJson(Map<String, dynamic> json) =>
      CreateTicketTaxType(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}

class CreateTicketTroubleType {
  final int? id;
  final String? title;

  CreateTicketTroubleType({this.id, this.title});

  factory CreateTicketTroubleType.fromJson(Map<String, dynamic> json) =>
      CreateTicketTroubleType(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
