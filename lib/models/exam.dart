// lib/models/exam.dart
import 'package:flutter/foundation.dart';

class Exam {
  final String name;
  final DateTime dateTime;
  final List<String> rooms;

  // Named parameters in constructor
  Exam({
    required this.name,
    required this.dateTime,
    required this.rooms,
  });
}
