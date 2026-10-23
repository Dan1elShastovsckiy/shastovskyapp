// lib/models/score_entry.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreEntry {
  final String userId;
  final String userName;
  final int score;
  final DateTime updatedAt;

  ScoreEntry({
    required this.userId,
    required this.userName,
    required this.score,
    required this.updatedAt,
  });

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      score: json['score'] as int,
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'score': score,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
