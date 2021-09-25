import 'package:flutter/material.dart';

class AdvancedTile {
  final String title;
  final String courseId;
  final String semester;
  final String submitCount;
  final String workCount;
  bool isExpanded;

  AdvancedTile({
    required this.title,
    required this.courseId,
    required this.semester,
    this.workCount = '0',
    this.submitCount = '0',
    this.isExpanded = false,
  });
}
