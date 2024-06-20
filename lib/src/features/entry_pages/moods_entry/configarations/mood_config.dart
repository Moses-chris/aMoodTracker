import 'package:flutter/material.dart';

class Mood {
  final String emojiPath;
  final String text;
  final Color color;
  final int score;

  Mood({
    required this.emojiPath,
    required this.text,
    required this.color,
    required this.score,
  });
}

final List<Mood> moods = [
  Mood(emojiPath: "assets/emojis/rage.png", text: "Angry", color: Color(0xFF9A031E), score: 1),
  Mood(emojiPath: "assets/emojis/white_frowning_face.png", text: "Sad", color: Colors.orange, score: 2),
  Mood(emojiPath: "assets/emojis/slightly_smiling_face.png", text: "Neutral", color: Colors.blue, score: 3),
  Mood(emojiPath: "assets/emojis/blush.png", text: "Happy", color: Colors.cyan, score: 4),
  Mood(emojiPath: "assets/emojis/laughing.png", text: "Excited", color: Colors.green, score: 5),
];

Mood getMoodDetails(String emojiPath) {
  return moods.firstWhere((mood) => mood.emojiPath == emojiPath, orElse: () => Mood(emojiPath: "", text: "Unknown", color: Colors.grey, score: 0));
}
