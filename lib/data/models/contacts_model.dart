class ContactsModel {
  final String title;
  final String number;

  ContactsModel({required this.title, required this.number});

  factory ContactsModel.fromJson(Map<String, dynamic> json) =>
      ContactsModel(title: json["title"], number: json["number"]);

  Map<String, dynamic> toJson() => {"title": title, "number": number};
}
