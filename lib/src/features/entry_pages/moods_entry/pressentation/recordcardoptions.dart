import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/entry_pages/moods_entry/data/moodlog/mood_entry.dart';

import 'moodlogscreen.dart';
import 'repositoryprovider.dart';

enum MoodRecordCardMenuOption { delete, edit, addNote, addPhoto }

class MoodRecordCardOptions extends StatelessWidget {
  const MoodRecordCardOptions({
    super.key,
    required this.id,
    required this.recordEntry,
    required this.record,
  });

  final dynamic id;
  final MapEntry<dynamic, MoodEntry> recordEntry;
  final MoodEntry record;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => PopupMenuButton<MoodRecordCardMenuOption>(
        onSelected: (value) {
          switch (value) {
            case MoodRecordCardMenuOption.delete:
              () {
                final repository = ref.read(moodRecordRepositoryProvider);
                repository.deleteMoodRecord(id);
              }();
              break;
            case MoodRecordCardMenuOption.edit:
              MoodRecordsScreen.showAddMoodRecordForm(context, recordEntry);
              break;
            default:
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem<MoodRecordCardMenuOption>(
              value: MoodRecordCardMenuOption.edit,
              child: Text("Edit"),
            ),
            // PopupMenuItem<MoodRecordCardMenuOption>(
            //   value: MoodRecordCardMenuOption.addNote,
            //   child: Text(record.note == null ? "Add Note".hardcoded : "Edit Note".hardcoded),
            // ),
            // PopupMenuItem<MoodRecordCardMenuOption>(
            //   value: MoodRecordCardMenuOption.addPhoto,
            //   child: Text("Add Photo".hardcoded),
            // ),
            const PopupMenuItem<MoodRecordCardMenuOption>(
              value: MoodRecordCardMenuOption.delete,
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ];
        },
      ),
    );
  }
}
