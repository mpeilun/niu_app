import 'dart:convert';

import 'package:flutter/material.dart';

class EschoolData {
  final String courseName;
  final String semester;
  final String announcementCount;
  final String workCount;

  EschoolData({
    required this.courseName,
    required this.semester,
    required this.announcementCount,
    required this.workCount,
  });

  factory EschoolData.fromJson(Map<String, dynamic> jsonData) {
    return EschoolData(
      courseName: jsonData['courseName'],
      semester: jsonData['semester'],
      announcementCount: jsonData['announcementCount'],
      workCount: jsonData['workCount'],
    );
  }

  static Map<String, dynamic> toMap(EschoolData eschoolData) => {
        'courseName': eschoolData.courseName,
        'semester': eschoolData.semester,
        'announcementCount': eschoolData.announcementCount,
        'workCount': eschoolData.workCount,
      };

  static String encode(List<EschoolData> eschoolData) => json.encode(
        eschoolData
            .map<Map<String, dynamic>>(
                (eschoolData) => EschoolData.toMap(eschoolData))
            .toList(),
      );

  static List<EschoolData> decode(String eschoolData) =>
      (json.decode(eschoolData) as List<dynamic>)
          .map<EschoolData>((item) => EschoolData.fromJson(item))
          .toList();
}
