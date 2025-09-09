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
  dynamic userId; // Ubah dari int? ke dynamic
  dynamic scheduleId; // Ubah dari int? ke dynamic
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic id; // Ubah dari int? ke dynamic
  Schedule? schedule;

  BookingData({
    this.userId,
    this.scheduleId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.schedule,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    userId: _parseDynamicToInt(json["user_id"]),
    scheduleId: _parseDynamicToInt(json["schedule_id"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"].toString()),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),
    id: _parseDynamicToInt(json["id"]),
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

  // Helper method untuk parsing dynamic ke int
  static int? _parseDynamicToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Schedule {
  dynamic id; // Ubah dari int? ke dynamic
  dynamic fieldId; // Ubah dari int? ke dynamic
  String? date;
  String? startTime;
  String? endTime;
  String? isBooked;
  DateTime? createdAt;
  DateTime? updatedAt;
  Field? field;

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
    id: _parseDynamicToInt(json["id"]),
    fieldId: _parseDynamicToInt(json["field_id"]),
    date: json["date"]?.toString(),
    startTime: json["start_time"]?.toString(),
    endTime: json["end_time"]?.toString(),
    isBooked: json["is_booked"]?.toString(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"].toString()),
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

  // Helper method untuk parsing dynamic ke int
  static int? _parseDynamicToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Field {
  dynamic id; // Ubah dari int? ke dynamic
  String? name;
  String? description;
  dynamic pricePerHour; // Ubah dari int? ke dynamic
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
    id: _parseDynamicToInt(json["id"]),
    name: json["name"]?.toString(),
    description: json["description"]?.toString(),
    pricePerHour: _parseDynamicToInt(json["price_per_hour"]),
    imageUrl: json["image_url"]?.toString(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"].toString()),
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

  // Helper method untuk parsing dynamic ke int
  static int? _parseDynamicToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
