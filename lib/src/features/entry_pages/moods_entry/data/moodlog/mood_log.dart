import 'dart:ui';
import 'package:hive/hive.dart';

part 'mood_log.g.dart';

@HiveType(typeId: 1)
class Mood extends HiveObject {
  @HiveField(0)
  String emojiPath;

  @HiveField(1)
  Color color;

  @HiveField(2)
  String text;

  @HiveField(3)
  int score;

  Mood({
    required this.emojiPath,
    required this.color,
    required this.text,
    required this.score,
  });
}
