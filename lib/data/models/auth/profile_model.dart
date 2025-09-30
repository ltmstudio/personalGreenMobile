class ProfileModel {
  final int id;
  final String userName;

  ProfileModel({required this.id, required this.userName});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      ProfileModel(id: json["id"], userName: json["username"]);
}
