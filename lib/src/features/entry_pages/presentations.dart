import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:io';
import 'moods_entry/data/moodlog/mood_entry.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class EntryListPage1 extends StatefulWidget {
  const EntryListPage1({
    super.key,
  });

  @override
  State<EntryListPage1> createState() => _EntryListPage1State();
}

class _EntryListPage1State extends State<EntryListPage1> {
  late Box<MoodEntry> moodEntryBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    moodEntryBox = await Hive.openBox<MoodEntry>('moodEntries');
    setState(() {}); // Refresh the UI after the box is opened
  }

  Map<DateTime, List<MoodEntry>> _groupEntriesByDate(List<MoodEntry> entries) {
    final Map<DateTime, List<MoodEntry>> groupedEntries = {};

    for (var entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (!groupedEntries.containsKey(date)) {
        groupedEntries[date] = [];
      }
      groupedEntries[date]!.add(entry);
    }

    return groupedEntries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Mood Entries',
          style: Mystyles.headingstyle
          ),
        backgroundColor: Mystyles.myappBarColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<MoodEntry>('moodEntries').listenable(),
        builder: (context, Box<MoodEntry> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No entries found.',
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          )),
            );
          }

          final entries = box.values.toList().cast<MoodEntry>();
          final groupedEntries = _groupEntriesByDate(entries);

          return ListView.builder(
            itemCount: groupedEntries.length,
            itemBuilder: (context, index) {
              final date = groupedEntries.keys.elementAt(index);
              final formattedDate = DateFormat('EEEE, MMMM d').format(date); // Format the date (day and month)
              final year = DateFormat('yyyy').format(date); // Format the year
              final entriesForDate = groupedEntries[date]!;

              return Card(
                color:const Color(0xFF050A30),
                elevation: 4,
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color:const Color(0xFF000C66),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: Mystyles.headingcardstyle, // Display the formatted day and month
                           ),
                          Text(
                            year, // Display the year
                            style: Mystyles.headingcardstyle,
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(entriesForDate.length, (entryIndex) {
                      final moodEntry = entriesForDate[entryIndex];
                      final formattedTime = DateFormat('h:mm a').format(moodEntry.date); // Format the time

                      return TimelineTile(
                        isFirst: entryIndex == 0,
                        isLast: entryIndex == entriesForDate.length - 1,
                        afterLineStyle: LineStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          thickness: 3,
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          constraints: const BoxConstraints(minHeight: 85),
                          child: ListTile(
                           
                            title: Row(
                              children: [
                                Text(
                                  moodEntry.mood.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: moodEntry.mood.color),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedTime, // Display the formatted time
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),

                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(' ${moodEntry.factors.join(', ')}',
                                style: Mystyles.textstyle),
                             
                              ],
                            ),
                            onTap: () => _showEntryDetails(context, moodEntry),
                          ),
                        ),
                        indicatorStyle: IndicatorStyle(
                          indicatorXY: 0.5,
                          padding: const EdgeInsets.all(1),
                          height: 50,
                          width: 50,
                          indicator: Image.asset(
                            moodEntry.mood.emojiPath,
                            // color: moodEntry.mood.color,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEntryDetails(BuildContext context, MoodEntry moodEntry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Mystyles.mybackgroundColor,
          title: const Text('Mood Entry Details'),
          content: SingleChildScrollView(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${moodEntry.date.toLocal()}'.split('.')[0]),
                  const SizedBox(height: 10),
                  Text('Mood: ${moodEntry.mood.text}'),
                  const SizedBox(height: 10),
                  Text('Factors: ${moodEntry.factors.join(', ')}'),
                  const SizedBox(height: 10),
                  Text('Journal: ${moodEntry.journal}'),
                  const SizedBox(height: 10),
                  if (moodEntry.imagePath != null)
                    Image.file(File(moodEntry.imagePath!)),
                  const SizedBox(height: 10),
                  if (moodEntry.audioPath != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add your audio playback functionality here
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play Audio'),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () => _editEntry(context, moodEntry),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => _deleteEntry(context, moodEntry),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editEntry(BuildContext context, MoodEntry moodEntry) {
    // Show a dialog or navigate to a screen to edit the entry
    Navigator.of(context).pop(); // Close the current dialog
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController moodController = TextEditingController(text: moodEntry.mood.text);
        final TextEditingController factorsController = TextEditingController(text: moodEntry.factors.join(', '));
        final TextEditingController journalController = TextEditingController(text: moodEntry.journal);

        return AlertDialog(
          title: const Text(
            'Edit Mood Entry', ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: moodController,
                  decoration: const InputDecoration(labelText: 'Mood'),
                ),
                TextField(
                  controller: factorsController,
                  decoration: const InputDecoration(labelText: 'Factors'),
                ),
                TextField(
                  controller: journalController,
                  decoration: const InputDecoration(labelText: 'Journal'),
                ),
                // Add fields for other editable properties as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the moodEntry with the new values
                moodEntry.mood.text = moodController.text;
                moodEntry.factors = factorsController.text.split(', ');
                moodEntry.journal = journalController.text;
                moodEntry.save(); // Save the updated entry to the Hive box

                Navigator.of(context).pop(); // Close the edit dialog
                setState(() {}); // Refresh the UI
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(BuildContext context, MoodEntry moodEntry) {
    Navigator.of(context).pop(); // Close the current dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                moodEntry.delete(); // Delete the entry from the Hive box
                Navigator.of(context).pop(); // Close the confirmation dialog
                setState(() {}); // Refresh the UI
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
