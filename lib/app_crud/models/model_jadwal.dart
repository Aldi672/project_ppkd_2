// To parse this JSON data, do
//
//     final jadwalLapangan = jadwalLapanganFromJson(jsonString);

import 'dart:convert';

JadwalLapangan jadwalLapanganFromJson(String str) =>
    JadwalLapangan.fromJson(json.decode(str));

String jadwalLapanganToJson(JadwalLapangan data) => json.encode(data.toJson());

class JadwalLapangan {
  String message;
  Data data;

  JadwalLapangan({required this.message, required this.data});

  factory JadwalLapangan.fromJson(Map<String, dynamic> json) => JadwalLapangan(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int fieldId;
  DateTime date;
  String startTime;
  String endTime;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  int isBooked;

  Data({
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.isBooked,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fieldId: json["field_id"],
    date: DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    isBooked: json["is_booked"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "field_id": fieldId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "is_booked": isBooked,
  };
}
