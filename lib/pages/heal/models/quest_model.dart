class Quest {
  final String questId;
  final String title;
  final String description;
  final int point;
  final String period;
  final String status;

  Quest({
    required this.questId,
    required this.title,
    required this.description,
    required this.point,
    required this.period,
    required this.status,
  });

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      questId: map['questId'],
      title: map['title'],
      description: map['description'],
      point: map['point'],
      period: map['period'],
      status: map['status'],
    );
  }
}
