// lib/main.dart
import 'package:flutter/material.dart';
import 'models/exam.dart';
import 'screens/exam_list_screen.dart';

void main() {
  runApp(const ExamApp());
}

class ExamApp extends StatelessWidget {
  const ExamApp({Key? key}) : super(key: key);

  List<Exam> _loadExams() {
    // Hardcoded list - промени датумите ако треба
    final now = DateTime.now();
    return [
      Exam(name: 'Математика 1', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: -5, hours: 10)), rooms: ['A101']),
      Exam(name: 'Физика', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: -1, hours: 9)), rooms: ['B201']),
      Exam(name: 'Програмски јазици', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 1, hours: 15, minutes: 35)), rooms: ['C305']),
      Exam(name: 'Алгоритми', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 5, hours: 9)), rooms: ['D110']),
      Exam(name: 'База на податоци', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 7, hours: 13)), rooms: ['E202', 'E203']),
      Exam(name: 'Оперативни системи', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 10, hours: 11)), rooms: ['F101']),
      Exam(name: 'Мрежи', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 12, hours: 15)), rooms: ['G304']),
      Exam(name: 'Вештачка интелигенција', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 15, hours: 10)), rooms: ['H210']),
      Exam(name: 'Системи за управување', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 20, hours: 9)), rooms: ['I101']),
      Exam(name: 'Економија', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 25, hours: 12)), rooms: ['J001']),
      Exam(name: 'Статистика', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 30, hours: 10)), rooms: ['K201']),
      Exam(name: 'Англиски јазик', dateTime: DateTime(now.year, now.month, now.day).add(Duration(days: 40, hours: 9)), rooms: ['L101']),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final exams = _loadExams()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return MaterialApp(
      title: 'Exam Schedule',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExamListScreen(exams: exams),
    );
  }
}
