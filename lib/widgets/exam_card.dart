// lib/widgets/exam_card.dart
import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'package:intl/intl.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({
    Key? key,
    required this.exam,
    required this.onTap,
  }) : super(key: key);

  bool get isPast => exam.dateTime.isBefore(DateTime.now());

  String get formattedDate {
    final df = DateFormat('dd.MM.yyyy');
    return df.format(exam.dateTime);
  }

  String get formattedTime {
    final tf = DateFormat('HH:mm');
    return tf.format(exam.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isPast ? Colors.grey[200] : Colors.white;
    final leadingIconColor = isPast ? Colors.grey : Colors.blueAccent;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: leadingIconColor,
          child: Icon(Icons.school, color: Colors.white),
        ),
        title: Text(exam.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 6),
              Text(formattedDate),
              SizedBox(width: 12),
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 6),
              Text(formattedTime),
            ]),
            SizedBox(height: 6),
            Row(children: [
              Icon(Icons.meeting_room, size: 16),
              SizedBox(width: 6),
              Expanded(child: Text(exam.rooms.join(', '), overflow: TextOverflow.ellipsis)),
            ]),
          ],
        ),
        trailing: isPast
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
