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
  final String id;
  final String title;
  final String content;
  final String type; // 'photo' or 'note'
  final String? imageUrl;
  final String coupleId;
  final String createdBy;
  final DateTime createdAt;
  final List<String> tags;

  Memory({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.imageUrl,
    required this.coupleId,
    required this.createdBy,
    required this.createdAt,
    this.tags = const [],
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      imageUrl: json['image_url'],
      coupleId: json['couple_id'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'image_url': imageUrl,
      'couple_id': coupleId,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'tags': tags,
    };
  }
}
