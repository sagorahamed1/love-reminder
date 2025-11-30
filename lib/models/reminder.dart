class Reminder {
  final String id;
  final String title;
  final String? message;
  final String time;
  final List<String> days;
  final String? emoji;
  final bool hasPhoto;
  final bool hasVoice;
  final String? photoUrl;
  final String? voiceUrl;
  final String fromUserId;
  final String toUserId;
  final bool completed;
  final DateTime? completedAt;
  final int streak;
  final bool isActive;
  final DateTime createdAt;
  final bool fromPartner;

  Reminder({
    required this.id,
    required this.title,
    this.message,
    required this.time,
    required this.days,
    this.emoji,
    this.hasPhoto = false,
    this.hasVoice = false,
    this.photoUrl,
    this.voiceUrl,
    required this.fromUserId,
    required this.toUserId,
    this.completed = false,
    this.completedAt,
    this.streak = 0,
    this.isActive = true,
    required this.createdAt,
    this.fromPartner = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      time: json['time'],
      days: List<String>.from(json['days'] ?? ['daily']),
      emoji: json['emoji'],
      hasPhoto: json['photo_url'] != null,
      hasVoice: json['voice_url'] != null,
      photoUrl: json['photo_url'],
      voiceUrl: json['voice_url'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
      completed: json['completed'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      streak: json['streak'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      fromPartner: json['from_partner'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'days': days,
      'emoji': emoji,
      'photo_url': photoUrl,
      'voice_url': voiceUrl,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'completed': completed,
      'completed_at': completedAt?.toIso8601String(),
      'streak': streak,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'from_partner': fromPartner,
    };
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    List<String>? days,
    String? emoji,
    bool? hasPhoto,
    bool? hasVoice,
    String? photoUrl,
    String? voiceUrl,
    String? fromUserId,
    String? toUserId,
    bool? completed,
    DateTime? completedAt,
    int? streak,
    bool? isActive,
    DateTime? createdAt,
    bool? fromPartner,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      days: days ?? this.days,
      emoji: emoji ?? this.emoji,
      hasPhoto: hasPhoto ?? this.hasPhoto,
      hasVoice: hasVoice ?? this.hasVoice,
      photoUrl: photoUrl ?? this.photoUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      streak: streak ?? this.streak,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      fromPartner: fromPartner ?? this.fromPartner,
    );
  }
}
