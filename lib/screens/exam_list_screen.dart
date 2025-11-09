// lib/screens/exam_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

class ExamListScreen extends StatelessWidget {
  final List<Exam> exams;

  const ExamListScreen({Key? key, required this.exams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure list already sorted by caller; but just in case:
    final sorted = [...exams]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text('Распоред за испити - 225080'), // промени го бројот на индекс
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final exam = sorted[index];
                return ExamCard(
                  exam: exam,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamDetailScreen(exam: exam),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Badge at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(

                  label: Text('Вкупно испити: ${sorted.length}'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
