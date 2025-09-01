import 'package:flutter/material.dart';

class Book {
  final int? id;
  final String title;
  final String author;
  final String description;
  final String genre;
  final int totalPages;
  final int currentPage;
  final String status; // 'reading', 'completed', 'to_read'
  final String? coverImagePath;
  final DateTime dateAdded;
  final DateTime? dateCompleted;
  final String? imagePath;
  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.totalPages,
    this.currentPage = 0,
    this.status = 'to_read',
    this.coverImagePath,
    required this.dateAdded,
    this.dateCompleted,
    this.imagePath,
  });
  // Convert Book to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'genre': genre,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'status': status,
      'coverImagePath': imagePath,
      'dateAdded': dateAdded.toIso8601String(),
      'dateCompleted': dateCompleted?.toIso8601String(),
    };
  }

  // Create Book from Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      genre: map['genre'],
      totalPages: map['totalPages'],
      currentPage: map['currentPage'] ?? 0,
      status: map['status'] ?? 'to_read',
      imagePath: map['coverImagePath'],
      coverImagePath: map['coverImagePath'],
      dateAdded: DateTime.parse(map['dateAdded']),
      dateCompleted: map['dateCompleted'] != null
          ? DateTime.parse(map['dateCompleted'])
          : null,
    );
  }
  // Calculate reading progress
  double get progress {
    if (totalPages <= 0) return 0.0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }

  // Get status color
  Color get statusColor {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'reading':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get status text
  String get statusText {
    switch (status) {
      case 'completed':
        return 'Selesai';
      case 'reading':
        return 'Sedang Dibaca';
      default:
        return 'Belum Dibaca';
    }
  }

  // Copy with method for updates
  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? description,
    String? genre,
    int? totalPages,
    int? currentPage,
    String? status,
    String? coverImagePath,
    DateTime? dateAdded,
    DateTime? dateCompleted,
    String? imagePath,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      dateAdded: dateAdded ?? this.dateAdded,
      dateCompleted: dateCompleted ?? this.dateCompleted,
    );
  }
}
