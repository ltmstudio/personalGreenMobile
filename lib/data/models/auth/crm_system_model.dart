
class CrmSystemModel {
  final Crm crm;
  final String token;

  CrmSystemModel({
    required this.crm,
    required this.token,
  });

  factory CrmSystemModel.fromJson(Map<String, dynamic> json) => CrmSystemModel(
    crm: Crm.fromJson(json["crm"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "crm": crm.toJson(),
    "token": token,
  };
}

class Crm {
  final int id;
  final String name;
  final String host;

  Crm({
    required this.id,
    required this.name,
    required this.host,
  });

  factory Crm.fromJson(Map<String, dynamic> json) => Crm(
    id: json["id"],
    name: json["name"],
    host: json["host"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "host": host,
  };
}
