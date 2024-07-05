import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../data/dataentry/refrection_data_entry.dart';

class ViewEntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Entries'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<JournalEntry>('journal_entries').listenable(),
        builder: (context, Box<JournalEntry> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No entries found.'));
          }

          final entries = box.values.toList().cast<JournalEntry>().reversed.toList();

          return ListView.builder(
            itemCount: entries.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final iconWidgets = entry.iconCodes
                  .map((codePoint) => Icon(IconData(codePoint, fontFamily: 'MaterialIcons')))
                  .toList();
              final categoryItems = entry.category.split(', ');

              return GestureDetector(
                onTap: () => _showEntryDetails(context, box, index, entry),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 3.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateHeader(entry.date),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategorySection(iconWidgets, categoryItems),
                            const SizedBox(height: 16.0),
                            _buildContentSection('Grateful for:', entry.gratefulFor),
                            const SizedBox(height: 16.0),
                            _buildContentSection('Other thoughts:', entry.otherThoughts),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(DateTime? date) {
    if (date == null) return SizedBox.shrink();
    
    final dayMonth = DateFormat('EEEE, MMMM d').format(date);
    final year = DateFormat('yyyy').format(date);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dayMonth,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Text(
            year,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(List<Icon> iconWidgets, List<String> categoryItems) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8.0,
      runSpacing: 8.0,
      children: List<Widget>.generate(iconWidgets.length, (i) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidgets[i],
              SizedBox(width: 4.0),
              Text(
                categoryItems[i],
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildContentSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        SizedBox(height: 4.0),
        Text(
          content,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  void _showEntryDetails(BuildContext context, Box<JournalEntry> box, int index, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Entry Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List<Widget>.generate(entry.iconCodes.length, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(IconData(entry.iconCodes[i], fontFamily: 'MaterialIcons')),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          color: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            entry.category.split(', ')[i],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Grateful for:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(entry.gratefulFor),
                const SizedBox(height: 8.0),
                const Text(
                  'Other thoughts:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(entry.otherThoughts),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () => _editEntry(context, box, index, entry),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => _deleteEntry(context, box, index),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editEntry(BuildContext context, Box<JournalEntry> box, int index, JournalEntry entry) {
    final TextEditingController gratefulController = TextEditingController(text: entry.gratefulFor);
    final TextEditingController thoughtsController = TextEditingController(text: entry.otherThoughts);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categories:'),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List<Widget>.generate(entry.iconCodes.length, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(IconData(entry.iconCodes[i], fontFamily: 'MaterialIcons')),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          color: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            entry.category.split(', ')[i],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 8.0),
                const Text('Grateful for:'),
                TextField(
                  controller: gratefulController,
                  decoration: const InputDecoration(hintText: 'I am grateful for ...'),
                ),
                const SizedBox(height: 8.0),
                const Text('Other thoughts:'),
                TextField(
                  controller: thoughtsController,
                  decoration: const InputDecoration(hintText: 'Today I learned ...'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                entry.gratefulFor = gratefulController.text.trim();
                entry.otherThoughts = thoughtsController.text.trim();
               // entry.save(); // Save the updated entry to the Hive box

                Navigator.of(context).pop(); // Close the edit dialog
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

  void _deleteEntry(BuildContext context, Box<JournalEntry> box, int index) {
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
                box.deleteAt(index); // Delete the entry from the Hive box
                Navigator.of(context).pop(); // Close the confirmation dialog
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
