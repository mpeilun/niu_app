import 'package:flutter/material.dart';

class AdvancedTile {
  final String title;
  final String courseId;
  final String workCount;
  final String submitCount;
  bool isExpanded;

  AdvancedTile({
    required this.title,
    required this.courseId,
    this.workCount = '0',
    this.submitCount = '0',
    this.isExpanded = false,
  });
}
