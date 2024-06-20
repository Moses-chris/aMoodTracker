import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/entry_pages/moods_entry/data/moodlog/mood_entry.dart';

import 'moodrecordcard.dart';

class MoodRecordGroup extends StatelessWidget {
  const MoodRecordGroup({super.key, required this.groupDate, required this.moodList});
  final DateTime groupDate;
  final List<MapEntry<dynamic, MoodEntry>> moodList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (moodList.length > 1)
            Container(
              margin: const EdgeInsets.only(top: 15, left: 15),
              child: Text(
                DateFormat('EEEE, MMMM d').format(groupDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ...moodList.map(
            (record) => MoodRecordCard(
              recordEntry: record,
              isFirst: record == moodList.first,
              isLast: record == moodList.last,
              showDate: moodList.length == 1,
            ),
          )
        ],
      ),
    );
  }
}
