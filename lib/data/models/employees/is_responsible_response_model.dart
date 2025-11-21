// To parse this JSON data, do
//
//     final isResponsibleResponseModel = isResponsibleResponseModelFromJson(jsonString);

import 'dart:convert';

IsResponsibleResponseModel isResponsibleResponseModelFromJson(String str) =>
    IsResponsibleResponseModel.fromJson(json.decode(str));

String isResponsibleResponseModelToJson(IsResponsibleResponseModel data) =>
    json.encode(data.toJson());

class IsResponsibleResponseModel {
  IsResponsibleData? data;

  IsResponsibleResponseModel({this.data});

  factory IsResponsibleResponseModel.fromJson(Map<String, dynamic> json) =>
      IsResponsibleResponseModel(
        data: json["data"] == null
            ? null
            : IsResponsibleData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class IsResponsibleData {
  bool? isResponsible;

  IsResponsibleData({this.isResponsible});

  factory IsResponsibleData.fromJson(Map<String, dynamic> json) =>
      IsResponsibleData(
        isResponsible: json["is_responsible"],
      );

  Map<String, dynamic> toJson() => {
        "is_responsible": isResponsible,
      };
}

