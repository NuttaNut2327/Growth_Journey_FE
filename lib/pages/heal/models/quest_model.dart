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
    final dynamic rawPeriod = map['period'] ?? map['estimate_time'] ?? 0;

    return Quest(
      questId: (map['questId'] ?? map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      point: (map['point'] ?? 0) as int,
      period: rawPeriod.toString(),
      status: (map['status'] ?? 'PENDING').toString(),
    );
  }

  Quest copyWith({
    String? questId,
    String? title,
    String? description,
    int? point,
    String? period,
    String? status,
  }) {
    return Quest(
      questId: questId ?? this.questId,
      title: title ?? this.title,
      description: description ?? this.description,
      point: point ?? this.point,
      period: period ?? this.period,
      status: status ?? this.status,
    );
  }
}
