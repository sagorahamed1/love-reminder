// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';

// class FilterChips extends StatelessWidget {
//   final List<Map<String, dynamic>> filters;
//   final String selectedFilter;
//   final Function(String) onFilterChanged;

//   const FilterChips({
//     super.key,
//     required this.filters,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: filters.map((filter) {
//           final isSelected = selectedFilter == filter['key'];

//           return Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: FilterChip(
//               selected: isSelected,
//               label: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     filter['icon'] as IconData,
//                     size: 16,
//                     color: isSelected ? Colors.white : AppColors.textSecondary,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     filter['label'] as String,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: isSelected ? Colors.white : AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//               onSelected: (selected) {
//                 onFilterChanged(filter['key'] as String);
//               },
//               backgroundColor: Colors.white,
//               selectedColor: AppColors.primary,
//               checkmarkColor: Colors.white,
//               side: BorderSide(
//                 color: isSelected ? AppColors.primary : Colors.grey.shade300,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

class Memory {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? title;
  final String? message;
  final List<String>? tags;
  final DateTime? dateTime;
  final List<String>? images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? favBy;
  final bool? isSender;
  final bool? isFavorited;
  final Receiver? sender;
  final Receiver? receiver;

  Memory({
    this.id,
    this.senderId,
    this.receiverId,
    this.title,
    this.message,
    this.tags,
    this.dateTime,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.favBy,
    this.isSender,
    this.isFavorited,
    this.sender,
    this.receiver,
  });

  factory Memory.fromJson(Map<String, dynamic> json) => Memory(
    id: json["_id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    title: json["title"],
    message: json["message"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]),
    dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
    images: json["images"] == null ? [] : List<String>.from(json["images"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    favBy: json["favBy"] == null ? [] : List<String>.from(json["favBy"]),
    isSender: json["isSender"],
    isFavorited: json["isFavorited"],
    sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
    receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "title": title,
    "message": message,
    "tags": tags,
    "dateTime": dateTime?.toIso8601String(),
    "images": images,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "favBy": favBy,
    "isSender": isSender,
    "isFavorited": isFavorited,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
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
