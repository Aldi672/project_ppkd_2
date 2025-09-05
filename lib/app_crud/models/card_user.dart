// To parse this JSON data, do
//
//     final sportCard = sportCardFromJson(jsonString);

import 'dart:convert';

SportCard sportCardFromJson(String str) => SportCard.fromJson(json.decode(str));

String sportCardToJson(SportCard data) => json.encode(data.toJson());

class SportCard {
  String? message;
  List<Datum> data;

  SportCard({required this.message, required this.data});

  factory SportCard.fromJson(Map<String, dynamic> json) => SportCard(
    message: json["message"] ?? "",
    data: List<Datum>.from((json["data"] ?? []).map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  String imagePath;
  String pricePerHour;
  String imageUrl;

  Datum({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
    required this.pricePerHour,
    required this.imageUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    createdAt:
        (json["created_at"] != null && json["created_at"].toString().isNotEmpty)
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),

    updatedAt:
        (json["updated_at"] != null && json["updated_at"].toString().isNotEmpty)
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),

    imagePath: json["image_path"] ?? "",
    pricePerHour: json["price_per_hour"]?.toString() ?? "0",
    imageUrl: json["image_url"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image_path": imagePath,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
  };
}
