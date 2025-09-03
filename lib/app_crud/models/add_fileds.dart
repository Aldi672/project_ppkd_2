// To parse this JSON data, do
//
//     final addFiled = addFiledFromJson(jsonString);

import 'dart:convert';

AddFiled addFiledFromJson(String str) => AddFiled.fromJson(json.decode(str));

String addFiledToJson(AddFiled data) => json.encode(data.toJson());

class AddFiled {
  String message;
  Data data;

  AddFiled({required this.message, required this.data});

  factory AddFiled.fromJson(Map<String, dynamic> json) =>
      AddFiled(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int id;
  String name;
  int pricePerHour;
  String imageUrl;
  String imagePath;

  Data({
    required this.id,
    required this.name,
    required this.pricePerHour,
    required this.imageUrl,
    required this.imagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    pricePerHour: json["price_per_hour"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
