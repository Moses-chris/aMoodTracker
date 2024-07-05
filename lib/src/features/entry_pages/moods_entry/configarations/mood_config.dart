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
  Mood(emojiPath: "assets/emojis/rage.png", text: "Angry", color: Color.fromARGB(255, 196, 4, 39), score: 1),
  Mood(emojiPath: "assets/emojis/white_frowning_face.png", text: "Sad", color: Color.fromARGB(255, 255, 152, 0), score: 2),
  Mood(emojiPath: "assets/emojis/slightly_smiling_face.png", text: "Neutral", color: Color.fromARGB(255, 0, 140, 255), score: 3),
  Mood(emojiPath: "assets/emojis/blush.png", text: "Happy", color: Color.fromARGB(255, 0, 225, 255), score: 4),
  Mood(emojiPath: "assets/emojis/laughing.png", text: "Excited", color: Color.fromARGB(255, 19, 220, 26), score: 5),
];

Mood getMoodDetails(String emojiPath) {
  return moods.firstWhere((mood) => mood.emojiPath == emojiPath, orElse: () => Mood(emojiPath: "", text: "Unknown", color: Colors.grey, score: 0));
}
