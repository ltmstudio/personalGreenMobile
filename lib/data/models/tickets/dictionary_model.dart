
class DictionaryModel {
  final List<StatusModel> statuses;
  final List<Type> taxTypes;
  final List<ServiceType> serviceTypes;
  final List<TroubleType> troubleTypes;
  final List<Type> priorityTypes;
  final List<SourceChannelType> sourceChannelTypes;

  DictionaryModel({
    required this.statuses,
    required this.taxTypes,
    required this.serviceTypes,
    required this.troubleTypes,
    required this.priorityTypes,
    required this.sourceChannelTypes,
  });

  factory DictionaryModel.fromJson(Map<String, dynamic> json) => DictionaryModel(
    statuses: List<StatusModel>.from(json["statuses"].map((x) => StatusModel.fromJson(x))),
    taxTypes: List<Type>.from(json["tax_types"].map((x) => Type.fromJson(x))),
    serviceTypes: List<ServiceType>.from(json["service_types"].map((x) => ServiceType.fromJson(x))),
    troubleTypes: List<TroubleType>.from(json["trouble_types"].map((x) => TroubleType.fromJson(x))),
    priorityTypes: List<Type>.from(json["priority_types"].map((x) => Type.fromJson(x))),
    sourceChannelTypes: List<SourceChannelType>.from(json["source_channel_types"].map((x) => SourceChannelType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuses": List<dynamic>.from(statuses.map((x) => x.toJson())),
    "tax_types": List<dynamic>.from(taxTypes.map((x) => x.toJson())),
    "service_types": List<dynamic>.from(serviceTypes.map((x) => x.toJson())),
    "trouble_types": List<dynamic>.from(troubleTypes.map((x) => x.toJson())),
    "priority_types": List<dynamic>.from(priorityTypes.map((x) => x.toJson())),
    "source_channel_types": List<dynamic>.from(sourceChannelTypes.map((x) => x.toJson())),
  };
}

class Type  {
  final int id;
  final String name;
  final String title;

  Type({
    required this.id,
    required this.name,
    required this.title,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "title": title,
  };
}

class ServiceType {
  final int id;
  final String title;
  final ServiceTypeOptions options;
  final List<TroubleType> troubleTypes;

  ServiceType({
    required this.id,
    required this.title,
    required this.options,
    required this.troubleTypes,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"],
    title: json["title"],
    options: ServiceTypeOptions.fromJson(json["options"]),
    troubleTypes: List<TroubleType>.from(json["trouble_types"].map((x) => TroubleType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "options": options.toJson(),
    "trouble_types": List<dynamic>.from(troubleTypes.map((x) => x.toJson())),
  };
}

class ServiceTypeOptions {
  final bool clientVisibility;
  final int rank;
  final String icon;

  ServiceTypeOptions({
    required this.clientVisibility,
    required this.rank,
    required this.icon,
  });

  factory ServiceTypeOptions.fromJson(Map<String, dynamic> json) => ServiceTypeOptions(
    clientVisibility: json["client_visibility"],
    rank: json["rank"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "client_visibility": clientVisibility,
    "rank": rank,
    "icon": icon,
  };
}

class TroubleType {
  final int id;
  final String title;
  final int serviceTypeId;
  final TroubleTypeOptions options;

  TroubleType({
    required this.id,
    required this.title,
    required this.serviceTypeId,
    required this.options,
  });

  factory TroubleType.fromJson(Map<String, dynamic> json) => TroubleType(
    id: json["id"],
    title: json["title"],
    serviceTypeId: json["service_type_id"],
    options: TroubleTypeOptions.fromJson(json["options"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "service_type_id": serviceTypeId,
    "options": options.toJson(),
  };
}

class TroubleTypeOptions {
  final bool clientVisibility;
  final String deadlineOffset;
  final int rank;
  final bool notify;

  TroubleTypeOptions({
    required this.clientVisibility,
    required this.deadlineOffset,
    required this.rank,
    required this.notify,
  });

  factory TroubleTypeOptions.fromJson(Map<String, dynamic> json) => TroubleTypeOptions(
    clientVisibility: json["client_visibility"],
    deadlineOffset: json[json["deadline_offset"]]!,
    rank: json["rank"],
    notify: json["notify"],
  );

  Map<String, dynamic> toJson() => {
    "client_visibility": clientVisibility,
    "deadline_offset": deadlineOffset,
    "rank": rank,
    "notify": notify,
  };
}



class SourceChannelType {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  SourceChannelType({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SourceChannelType.fromJson(Map<String, dynamic> json) => SourceChannelType(
    id: json["id"],
    title: json["title"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class StatusModel {
  final String name;
  final String title;
  final String color;

  StatusModel({
    required this.name,
    required this.title,
    required this.color,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
