class MoodModel {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? type;
  final String? message;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isSender;
  final Receiver? sender;
  final Receiver? receiver;
  final String? moodModelId;

  MoodModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSender,
    this.sender,
    this.receiver,
    this.moodModelId,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) => MoodModel(
    id: json["_id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    type: json["type"],
    message: json["message"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isSender: json["isSender"],
    sender: json["sender"] == null
        ? null
        : Receiver.fromJson(json["sender"]),
    receiver: json["receiver"] == null
        ? null
        : Receiver.fromJson(json["receiver"]),
    moodModelId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "type": type,
    "message": message,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isSender": isSender,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "id": moodModelId,
  };

  // Helper methods to match existing UI expectations
  String get mood => type ?? 'happy';
  String? get note => message;
  String get userId => senderId ?? '';
  DateTime get timestamp => createdAt ?? DateTime.now();

  // Get partner name for display
  String getPartnerName() {
    if (isSender == false && sender != null) {
      return sender!.name ?? 'Partner';
    } else if (isSender == true && receiver != null) {
      return receiver!.name ?? 'Partner';
    }
    return 'Partner';
  }
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