// To parse this JSON data, do
//
//     final addressesResponseModel = addressesResponseModelFromJson(jsonString);

import 'dart:convert';

AddressesResponseModel addressesResponseModelFromJson(String str) =>
    AddressesResponseModel.fromJson(json.decode(str));

String addressesResponseModelToJson(AddressesResponseModel data) =>
    json.encode(data.toJson());

class AddressesResponseModel {
  final List<AddressData>? data;
  final AddressLinks? links;
  final AddressMeta? meta;

  AddressesResponseModel({this.data, this.links, this.meta});

  factory AddressesResponseModel.fromJson(Map<String, dynamic> json) =>
      AddressesResponseModel(
        data: json["data"] == null
            ? []
            : List<AddressData>.from(
                json["data"]!.map((x) => AddressData.fromJson(x)),
              ),
        links: json["links"] == null
            ? null
            : AddressLinks.fromJson(json["links"]),
        meta: json["meta"] == null ? null : AddressMeta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class AddressData {
  final int? id;
  final AddressType? type;
  final String? address;

  AddressData({this.id, this.type, this.address});

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    id: json["id"],
    type: json["type"] == null ? null : addressTypeValues.map[json["type"]],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type == null ? null : addressTypeValues.reverse[type],
    "address": address,
  };
}

enum AddressType { house, space }

final addressTypeValues = EnumValues({
  "house": AddressType.house,
  "space": AddressType.space,
});

class AddressLinks {
  final String? first;
  final String? last;
  final dynamic prev;
  final String? next;

  AddressLinks({this.first, this.last, this.prev, this.next});

  factory AddressLinks.fromJson(Map<String, dynamic> json) => AddressLinks(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class AddressMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<AddressMetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  AddressMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory AddressMeta.fromJson(Map<String, dynamic> json) => AddressMeta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<AddressMetaLink>.from(
            json["links"]!.map((x) => AddressMetaLink.fromJson(x)),
          ),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class AddressMetaLink {
  final String? url;
  final String? label;
  final bool? active;

  AddressMetaLink({this.url, this.label, this.active});

  factory AddressMetaLink.fromJson(Map<String, dynamic> json) =>
      AddressMetaLink(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
