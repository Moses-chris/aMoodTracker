import 'package:hive/hive.dart';

part 'refrection_data_entry.g.dart';

@HiveType(typeId: 2)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  String gratefulFor;

  @HiveField(2)
  String otherThoughts;

  @HiveField(3)
  List<int> iconCodes;

  @HiveField(4)
  DateTime? date;

  JournalEntry({
    required this.category,
    required this.gratefulFor,
    required this.otherThoughts,
    required this.date,
    List<int>? iconCodes,
  }) : iconCodes = iconCodes ?? [];

}

// refrection_data_entry.g.dart

class JournalEntrAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 2;

  @override
  JournalEntry read(BinaryReader reader) {
    return JournalEntry(
      category: reader.readString(),
      gratefulFor: reader.readString(),
      otherThoughts: reader.readString(),
      date: reader.read() as DateTime?, // Ensure that it reads DateTime? properly
      iconCodes: (reader.read() as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeString(obj.category)
      ..writeString(obj.gratefulFor)
      ..writeString(obj.otherThoughts)
      ..write(obj.date) // No cast needed, DateTime? is supported
      ..write(obj.iconCodes);
  }
}
