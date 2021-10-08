import 'package:flutter/material.dart';

class EschoolData {
  final String title;
  final String courseId;
  final String semester;
  final String announcementCount;
  final String workCount;

  EschoolData({
    required this.title,
    required this.courseId,
    required this.semester,
    this.announcementCount = '0',
    this.workCount = '0',
  });
}
