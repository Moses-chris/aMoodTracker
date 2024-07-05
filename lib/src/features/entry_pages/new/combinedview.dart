import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../moods_entry/data/moodlog/mood_entry.dart';
import '../refrection_entries/data/dataentry/refrection_data_entry.dart';
import 'combined_card.dart';


class ViewEntriesPage1 extends StatelessWidget {
  const ViewEntriesPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<JournalEntry>('journal_entries').listenable(),
        builder: (context, Box<JournalEntry> journalBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<MoodEntry>('moodEntries').listenable(),
            builder: (context, Box<MoodEntry> moodBox, _) {
              if (journalBox.isEmpty && moodBox.isEmpty) {
                return const Center(child: Text('No entries found.'));
              }

              final combinedEntries = _combineEntries(journalBox, moodBox);

              return ListView.builder(
                itemCount: combinedEntries.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) {
                  final date = combinedEntries.keys.elementAt(index);
                  final entries = combinedEntries[date]!;

                  return CombinedEntryCard(
                    date: date,
                    reflectionEntries: entries.reflections,
                    moodEntries: entries.moods,
                    onAddEntry: () {},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Map<DateTime, CombinedEntries> _combineEntries(Box<JournalEntry> journalBox, Box<MoodEntry> moodBox) {
    final Map<DateTime, CombinedEntries> combinedEntries = {};

    for (var entry in journalBox.values) {
      final date = DateTime(entry.date!.year, entry.date!.month, entry.date!.day);
      if (!combinedEntries.containsKey(date)) {
        combinedEntries[date] = CombinedEntries([], []);
      }
      combinedEntries[date]!.reflections.add(entry);
    }

    for (var entry in moodBox.values) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (!combinedEntries.containsKey(date)) {
        combinedEntries[date] = CombinedEntries([], []);
      }
      combinedEntries[date]!.moods.add(entry);
    }

    return Map.fromEntries(combinedEntries.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));
  }
}

class CombinedEntries {
  final List<JournalEntry> reflections;
  final List<MoodEntry> moods;

  CombinedEntries(this.reflections, this.moods);
}