// To parse this JSON data, do
//
//     final getJadwal = getJadwalFromJson(jsonString);

import 'dart:convert';

GetJadwal getJadwalFromJson(String str) => GetJadwal.fromJson(json.decode(str));

String getJadwalToJson(GetJadwal data) => json.encode(data.toJson());

class GetJadwal {
  String? message;
  List<Data> data;

  GetJadwal({this.message, required this.data});

  factory GetJadwal.fromJson(Map<String, dynamic> json) => GetJadwal(
    message: json['message'] ?? '',
    data: (json['data'] as List).map((e) => Data.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Data {
  int? id;
  String? fieldId;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? isBooked;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.fieldId,
    this.date,
    this.startTime,
    this.endTime,
    this.isBooked,
    this.createdAt,
    this.updatedAt,
  });

  // Di file models/gets_model.dart

  // ... properti lainnya

  Data copyWith({
    int? id,
    String? fieldId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? isBooked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBooked: isBooked ?? this.isBooked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fieldId: json["field_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    isBooked: json["is_booked"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field_id": fieldId,
    "date": date != null
        ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
        : null,
    "start_time": startTime,
    "end_time": endTime,
    "is_booked": isBooked,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
