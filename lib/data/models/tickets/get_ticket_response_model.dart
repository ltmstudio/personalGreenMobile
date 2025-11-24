// To parse this JSON data, do
//
//     final getTicketResponseModel = getTicketResponseModelFromJson(jsonString);

import 'dart:convert';

GetTicketResponseModel getTicketResponseModelFromJson(String str) =>
    GetTicketResponseModel.fromJson(json.decode(str));

String getTicketResponseModelToJson(GetTicketResponseModel data) =>
    json.encode(data.toJson());

class GetTicketResponseModel {
  Data? data;

  GetTicketResponseModel({this.data});

  factory GetTicketResponseModel.fromJson(Map<String, dynamic> json) =>
      GetTicketResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  int? id;
  dynamic visitingAt;
  PriorityType? status;
  Type? taxType;
  Type? troubleType;
  PriorityType? priorityType;
  Object? object;
  String? section;
  dynamic resident;
  dynamic contactPhone;
  dynamic sourceChannelType;
  Type? serviceType;
  bool? executorByManual;
  int? executorId;
  Executor? executor;
  dynamic comment;
  dynamic photos;
  DateTime? createdAt;

  Data({
    this.id,
    this.visitingAt,
    this.status,
    this.taxType,
    this.troubleType,
    this.priorityType,
    this.object,
    this.section,
    this.resident,
    this.contactPhone,
    this.sourceChannelType,
    this.serviceType,
    this.executorByManual,
    this.executorId,
    this.executor,
    this.comment,
    this.photos,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    visitingAt: json["visiting_at"],
    status: json["status"] == null
        ? null
        : PriorityType.fromJson(json["status"]),
    taxType: json["tax_type"] == null ? null : Type.fromJson(json["tax_type"]),
    troubleType: json["trouble_type"] == null
        ? null
        : Type.fromJson(json["trouble_type"]),
    priorityType: json["priority_type"] == null
        ? null
        : PriorityType.fromJson(json["priority_type"]),
    object: json["object"] == null ? null : Object.fromJson(json["object"]),
    section: json["section"],
    resident: json["resident"],
    contactPhone: json["contact_phone"],
    sourceChannelType: json["source_channel_type"],
    serviceType: json["service_type"] == null
        ? null
        : Type.fromJson(json["service_type"]),
    executorByManual: json["executor_by_manual"],
    executorId: json["executor_id"],
    executor: json["executor"] == null
        ? null
        : Executor.fromJson(json["executor"]),
    comment: json["comment"],
    photos: json["photos"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visiting_at": visitingAt,
    "status": status?.toJson(),
    "tax_type": taxType?.toJson(),
    "trouble_type": troubleType?.toJson(),
    "priority_type": priorityType?.toJson(),
    "object": object?.toJson(),
    "section": section,
    "resident": resident,
    "contact_phone": contactPhone,
    "source_channel_type": sourceChannelType,
    "service_type": serviceType?.toJson(),
    "executor_by_manual": executorByManual,
    "executor_id": executorId,
    "executor": executor?.toJson(),
    "comment": comment,
    "photos": photos,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Object {
  ResidentComplex? residentComplex;
  dynamic residentComplexId;
  String? houseNumber;
  int? houseId;
  dynamic spaceId;
  String? ls;
  String? address;
  Street? street;
  City? region;
  City? city;

  Object({
    this.residentComplex,
    this.residentComplexId,
    this.houseNumber,
    this.houseId,
    this.spaceId,
    this.ls,
    this.address,
    this.street,
    this.region,
    this.city,
  });

  factory Object.fromJson(Map<String, dynamic> json) => Object(
    residentComplex: json["resident_complex"] == null
        ? null
        : ResidentComplex.fromJson(json["resident_complex"]),
    residentComplexId: json["resident_complex_id"],
    houseNumber: json["house_number"],
    houseId: json["house_id"],
    spaceId: json["space_id"],
    ls: json["ls"],
    address: json["address"],
    street: json["street"] == null ? null : Street.fromJson(json["street"]),
    region: json["region"] == null ? null : City.fromJson(json["region"]),
    city: json["city"] == null ? null : City.fromJson(json["city"]),
  );

  Map<String, dynamic> toJson() => {
    "resident_complex": residentComplex?.toJson(),
    "resident_complex_id": residentComplexId,
    "house_number": houseNumber,
    "house_id": houseId,
    "space_id": spaceId,
    "ls": ls,
    "address": address,
    "street": street?.toJson(),
    "region": region?.toJson(),
    "city": city?.toJson(),
  };
}

class City {
  int? id;
  String? fullName;
  String? name;
  String? type;
  String? typeShort;
  String? fias;
  String? regionFias;

  City({
    this.id,
    this.fullName,
    this.name,
    this.type,
    this.typeShort,
    this.fias,
    this.regionFias,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    fullName: json["full_name"],
    name: json["name"],
    type: json["type"],
    typeShort: json["type_short"],
    fias: json["fias"],
    regionFias: json["region_fias"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "name": name,
    "type": type,
    "type_short": typeShort,
    "fias": fias,
    "region_fias": regionFias,
  };
}

class ResidentComplex {
  dynamic id;
  dynamic name;

  ResidentComplex({this.id, this.name});

  factory ResidentComplex.fromJson(Map<String, dynamic> json) =>
      ResidentComplex(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Street {
  int? id;
  String? fullName;
  String? streetName;
  String? streetType;
  String? streetTypeShort;
  dynamic settlementType;
  dynamic settlementTypeShort;
  dynamic settlementName;
  String? fias;
  dynamic settlementFias;
  String? cityFias;

  Street({
    this.id,
    this.fullName,
    this.streetName,
    this.streetType,
    this.streetTypeShort,
    this.settlementType,
    this.settlementTypeShort,
    this.settlementName,
    this.fias,
    this.settlementFias,
    this.cityFias,
  });

  factory Street.fromJson(Map<String, dynamic> json) => Street(
    id: json["id"],
    fullName: json["full_name"],
    streetName: json["street_name"],
    streetType: json["street_type"],
    streetTypeShort: json["street_type_short"],
    settlementType: json["settlement_type"],
    settlementTypeShort: json["settlement_type_short"],
    settlementName: json["settlement_name"],
    fias: json["fias"],
    settlementFias: json["settlement_fias"],
    cityFias: json["city_fias"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "street_name": streetName,
    "street_type": streetType,
    "street_type_short": streetTypeShort,
    "settlement_type": settlementType,
    "settlement_type_short": settlementTypeShort,
    "settlement_name": settlementName,
    "fias": fias,
    "settlement_fias": settlementFias,
    "city_fias": cityFias,
  };
}

class PriorityType {
  int? id;
  String? title;
  String? name;
  String? color;

  PriorityType({this.id, this.title, this.name, this.color});

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

class Type {
  int? id;
  String? title;

  Type({this.id, this.title});

  factory Type.fromJson(Map<String, dynamic> json) =>
      Type(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
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
