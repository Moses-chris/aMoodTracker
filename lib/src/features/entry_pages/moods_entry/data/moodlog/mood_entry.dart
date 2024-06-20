import 'package:hive/hive.dart';
import 'mood_log.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  Mood mood;

  @HiveField(1)
  List<String> factors;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String journal;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String? audioPath;

  MoodEntry({
    required this.mood,
    required this.factors,
    required this.date,
    required this.journal,
    this.imagePath,
    this.audioPath,
  });
}
