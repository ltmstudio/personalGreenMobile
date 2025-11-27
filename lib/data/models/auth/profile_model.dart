class ProfileModel {
  final int id;
  final String userName;
  final String? fullName;
  final String? position;
  final String? phone;
  final String? email;
  final String? name;
  final String? lastname;
  final String? surname;

  ProfileModel({
    required this.id,
    required this.userName,
    this.fullName,
    this.position,
    this.phone,
    this.email,
    this.name,
    this.lastname,
    this.surname,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Собираем fullName из отдельных полей, если оно не пришло
    String? fullName = json["full_name"] ?? json["fullName"];
    if (fullName == null || fullName.isEmpty) {
      final name = json["name"] ?? '';
      final lastname = json["lastname"] ?? '';
      final surname = json["surname"] ?? '';
      final parts = [
        name,
        lastname,
        surname,
      ].where((p) => p.isNotEmpty).toList();
      if (parts.isNotEmpty) {
        fullName = parts.join(' ');
      }
    }

    // Определяем userName из различных вариантов
    String userName = '';
    if (json["username"] != null &&
        json["username"].toString().trim().isNotEmpty) {
      userName = json["username"].toString().trim();
    } else if (json["userName"] != null &&
        json["userName"].toString().trim().isNotEmpty) {
      userName = json["userName"].toString().trim();
    } else if (json["name"] != null &&
        json["name"].toString().trim().isNotEmpty) {
      userName = json["name"].toString().trim();
    } else if (fullName != null && fullName.isNotEmpty) {
      userName = fullName;
    } else {
      userName = 'Пользователь';
    }

    return ProfileModel(
      id: json["id"],
      userName: userName,
      fullName: fullName,
      position: json["position"],
      phone: json["phone"],
      email: json["email"],
      name: json["name"],
      lastname: json["lastname"],
      surname: json["surname"],
    );
  }
}
