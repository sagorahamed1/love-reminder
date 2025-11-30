class Mood {
  final String id;
  final String userId;
  final String mood;
  final String? note;
  final DateTime timestamp;

  Mood({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.timestamp,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'],
      userId: json['user_id'],
      mood: json['mood'],
      note: json['note'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
