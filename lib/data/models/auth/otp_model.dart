class OtpModel {
  final String session;
  final String code;

  factory OtpModel.fromJson(Map<String, dynamic> json) =>
      OtpModel(session: json["data"]["session"], code: json["data"]["code"]);

  OtpModel({required this.session, required this.code});

  Map<String, dynamic> toJson() => {
    "data": {"session": session, "code": code},
  };
}
