import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationItem {
  final int icon;
  final String title;
  bool isNew;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.isNew,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> jsonData) {
    return NotificationItem(
      icon: jsonData['icon'],
      title: jsonData['title'],
      isNew: jsonData['isNew'],
    );
  }

  static Map<String, dynamic> toMap(NotificationItem notificationItem) => {
        'icon': notificationItem.icon,
        'title': notificationItem.title,
        'isNew': notificationItem.isNew,
      };

  static String encode(List<NotificationItem> notificationItem) => json.encode(
        notificationItem
            .map<Map<String, dynamic>>(
                (eschoolData) => NotificationItem.toMap(eschoolData))
            .toList(),
      );

  static List<NotificationItem> decode(String notificationItem) =>
      (json.decode(notificationItem) as List<dynamic>)
          .map<NotificationItem>((item) => NotificationItem.fromJson(item))
          .toList();
}
