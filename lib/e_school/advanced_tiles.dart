
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

class LearningTile {
  final String title;
  final String contents;

  LearningTile({
    required this.title,
    required this.contents,
  });
}

class LearningTiles {
  final List<LearningTile> tiles;
  bool isExpanded;

  LearningTiles({
    required this.tiles,
    this.isExpanded = false,
  });
}
