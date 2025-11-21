// To parse this JSON data, do
//
//     final getEmployeeResponseModel = getEmployeeResponseModelFromJson(jsonString);

import 'dart:convert';

GetEmployeeResponseModel getEmployeeResponseModelFromJson(String str) =>
    GetEmployeeResponseModel.fromJson(json.decode(str));

String getEmployeeResponseModelToJson(GetEmployeeResponseModel data) =>
    json.encode(data.toJson());

class GetEmployeeResponseModel {
  List<Employee>? data;

  GetEmployeeResponseModel({this.data});

  factory GetEmployeeResponseModel.fromJson(Map<String, dynamic> json) =>
      GetEmployeeResponseModel(
        data: json["data"] == null
            ? []
            : List<Employee>.from(
                json["data"]!.map((x) => Employee.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Employee {
  int? id;
  String? name;
  String? lastname;
  String? surname;
  String? fullName;
  String? position;
  String? statistics;

  Employee({
    this.id,
    this.name,
    this.lastname,
    this.surname,
    this.fullName,
    this.position,
    this.statistics,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        surname: json["surname"],
        fullName: json["full_name"],
        position: json["position"],
        statistics: json["statistics"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "surname": surname,
        "full_name": fullName,
        "position": position,
        "statistics": statistics,
      };
}

