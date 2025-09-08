// booking_lapangan.dart
import 'dart:convert';

BookingLapangan bookingLapanganFromJson(String str) =>
    BookingLapangan.fromJson(json.decode(str));

String bookingLapanganToJson(BookingLapangan data) =>
    json.encode(data.toJson());

class BookingLapangan {
  String? message;
  BookingData? data;

  BookingLapangan({this.message, this.data});

  factory BookingLapangan.fromJson(Map<String, dynamic> json) =>
      BookingLapangan(
        message: json["message"],
        data: json["data"] == null ? null : BookingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class BookingData {
  int? userId;
  int? scheduleId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  Schedule? schedule; // Tambahkan field schedule

  BookingData({
    this.userId,
    this.scheduleId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.schedule,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    userId: json["user_id"],
    scheduleId: json["schedule_id"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
    schedule: json["schedule"] == null
        ? null
        : Schedule.fromJson(json["schedule"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "schedule_id": scheduleId,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "schedule": schedule?.toJson(),
  };
}

class Schedule {
  int? id;
  int? fieldId;
  String? date;
  String? startTime;
  String? endTime;
  String? isBooked;
  DateTime? createdAt;
  DateTime? updatedAt;
  Field? field; // Tambahkan field information

  Schedule({
    this.id,
    this.fieldId,
    this.date,
    this.startTime,
    this.endTime,
    this.isBooked,
    this.createdAt,
    this.updatedAt,
    this.field,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    fieldId: json["field_id"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    isBooked: json["is_booked"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    field: json["field"] == null ? null : Field.fromJson(json["field"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field_id": fieldId,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "is_booked": isBooked,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "field": field?.toJson(),
  };
}

class Field {
  int? id;
  String? name;
  String? description;
  int? pricePerHour;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Field({
    this.id,
    this.name,
    this.description,
    this.pricePerHour,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pricePerHour: json["price_per_hour"],
    imageUrl: json["image_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
