// lib/screens/exam_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({Key? key, required this.exam}) : super(key: key);

  String timeRemainingText() {
    final now = DateTime.now();
    final diff = exam.dateTime.difference(now);

    if (diff.isNegative) {
      return 'Испитот е поминат';
    }

    final totalHours = diff.inHours;
    final days = totalHours ~/ 24;
    final hours = totalHours % 24;

    return '$days дена, $hours часа';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd.MM.yyyy').format(exam.dateTime);
    final timeFormatted = DateFormat('HH:mm').format(exam.dateTime);

    return Scaffold(
      appBar: AppBar(title: Text(exam.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Датум'),
              subtitle: Text(dateFormatted),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Време'),
              subtitle: Text(timeFormatted),
            ),
            ListTile(
              leading: Icon(Icons.meeting_room),
              title: Text('Простории'),
              subtitle: Text(exam.rooms.join(', ')),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.hourglass_bottom),
                SizedBox(width: 8),
                Text('Време до испит:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text(timeRemainingText()),
              ],
            ),
            SizedBox(height: 20),
            // Дополнителна информација
            if (!exam.dateTime.isBefore(DateTime.now()))
              Text('Ве молиме да дојдете 10 минути порано за да се може да се почне навреме со испитот.'),
          ],
        ),
      ),
    );
  }
}
