// To parse this JSON data, do
//
//     final getReminderModel = getReminderModelFromJson(jsonString);

import 'dart:convert';

GetReminderModel getReminderModelFromJson(String str) => GetReminderModel.fromJson(json.decode(str));

String getReminderModelToJson(GetReminderModel data) => json.encode(data.toJson());

class GetReminderModel {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? title;
  final String? message;
  final String? repeat;
  final DateTime? date;
  final String? time;
  final String? emoji;
  final bool? completed; // Add completed property for UI
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isOwn;
  final Receiver? sender;
  final Receiver? receiver;
  final String? getReminderModelId;

  GetReminderModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.title,
    this.message,
    this.repeat,
    this.date,
    this.time,
    this.emoji,
    this.completed,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isOwn,
    this.sender,
    this.receiver,
    this.getReminderModelId,
  });

  factory GetReminderModel.fromJson(Map<String, dynamic> json) => GetReminderModel(
    id: json["_id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    title: json["title"],
    message: json["message"],
    repeat: json["repeat"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    emoji: json["emoji"],
    completed: json["completed"], // Add completed from API response
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isOwn: json["isOwn"],
    sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
    receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
    getReminderModelId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "title": title,
    "message": message,
    "repeat": repeat,
    "date": date?.toIso8601String(),
    "time": time,
    "emoji": emoji,
    "completed": completed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isOwn": isOwn,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "id": getReminderModelId,
  };
}

class Receiver {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? receiverId;

  Receiver({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.receiverId,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profileImage"],
    receiverId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "profileImage": profileImage,
    "id": receiverId,
  };
}
