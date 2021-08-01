import 'package:flutter/material.dart';

class AdvancedTile {
  final String title;
  final IconData? icon;
  final bool isSubmit;
  final List<AdvancedTile> tiles;
  bool isExpanded;

  AdvancedTile({
    required this.title,
    this.icon,
    this.isSubmit = false,
    this.tiles = const [],
    this.isExpanded = false,
  });
}
