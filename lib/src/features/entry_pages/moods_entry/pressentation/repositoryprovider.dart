import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:myapp/src/features/entry_pages/moods_entry/data/moodlog/mood_entry.dart';

class MoodRecordRepository {
  MoodRecordRepository(this._moodRecordBox);
  final Box<MoodEntry> _moodRecordBox;

  Box<MoodEntry> get box => _moodRecordBox;

  static Future<MoodRecordRepository> createRepository() async {
    final box = await Hive.openBox<MoodEntry>("mood_records");
    // ref.onDispose(() => box.close());
    return MoodRecordRepository(box);
  }

  Future<int> createMoodRecord(MoodEntry record) {
    return _moodRecordBox.add(record);
  }

  Map<dynamic, MoodEntry> fetchMoodRecords() {
    return _moodRecordBox.toMap();
  }

  Future<void> updateMoodRecord(int key, MoodEntry record) {
    return _moodRecordBox.put(key, record);
  }

  Future<void> deleteMoodRecord(int key) {
    return _moodRecordBox.delete(key);
  }

  Map<dynamic, MoodEntry> fetchMoodRecordsByDate({required DateTime before, required DateTime after}) {
    final map = _moodRecordBox.toMap();
    map.removeWhere((key, value) => (value.date.compareTo(before) >= 0 || value.date.compareTo(after) <= 0));
    return map;
  }
}

final moodRecordRepositoryProvider = Provider<MoodRecordRepository>((ref) {
  // to acces this provider synchronously, this provider is overriden at the ProviderScope
  throw UnimplementedError();
});

final moodRecordsProvider = Provider<Map<dynamic, MoodEntry>>((ref) {
  final moodRecordRepository = ref.watch(moodRecordRepositoryProvider);
  return moodRecordRepository.fetchMoodRecords();
});
