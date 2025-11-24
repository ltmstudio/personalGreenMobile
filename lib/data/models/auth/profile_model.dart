class ProfileModel {
  final int id;
  final String userName;
  final String? fullName;
  final String? position;
  final String? phone;
  final String? email;

  ProfileModel({
    required this.id,
    required this.userName,
    this.fullName,
    this.position,
    this.phone,
    this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        userName: json["username"] ?? json["userName"] ?? '',
        fullName: json["full_name"] ?? json["fullName"],
        position: json["position"],
        phone: json["phone"],
        email: json["email"],
      );
}
