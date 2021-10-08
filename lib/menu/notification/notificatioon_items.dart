import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationItem {
  final int icon;
  final String title;

  NotificationItem({
    required this.icon,
    required this.title,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> jsonData) {
    return NotificationItem(
      icon: jsonData['icon'],
      title: jsonData['title'],
    );
  }

  static Map<String, dynamic> toMap(NotificationItem notificationItem) => {
        'icon': notificationItem.icon,
        'title': notificationItem.title,
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
