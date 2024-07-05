import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../moods_entry/data/moodlog/mood_entry.dart';
import '../refrection_entries/data/dataentry/refrection_data_entry.dart';
import 'showdialog.dart';

class CombinedEntryCard extends StatelessWidget {
  final DateTime date;
  final List<JournalEntry> reflectionEntries;
  final List<MoodEntry> moodEntries;
  final VoidCallback onAddEntry;
  
  CombinedEntryCard({
    super.key,
    required this.date,
    required List<JournalEntry> reflectionEntries,
    required List<MoodEntry> moodEntries,
    required this.onAddEntry,
  }) : 
    reflectionEntries = List<JournalEntry>.from(reflectionEntries)..sort((a, b) => b.date!.compareTo(a.date!)),
    moodEntries = List<MoodEntry>.from(moodEntries)..sort((a, b) => b.date.compareTo(a.date));

  @override
  Widget build(BuildContext context) {
  final borderColor = moodEntries.isNotEmpty
        ? moodEntries.first.mood.color
        : Colors.blueGrey[800]!;

    return Card(
      color: Color(0xFF050A30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),

      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildMoodColumn(context)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildReflectionColumn(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    final dayMonth = DateFormat('EEEE, MMMM d').format(date);
    final year = DateFormat('yyyy').format(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: moodEntries.isNotEmpty
            ? moodEntries.first.mood.color.withOpacity(0.7)
            : Colors.blueGrey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              dayMonth,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            year,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Reflections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF009688),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (reflectionEntries.isNotEmpty)
          ...reflectionEntries.map((entry) => _buildReflectionEntry(context, entry))
        else
          _buildNoEntryMessage(context, isReflection: true),
      ],
    );
  }

  Widget _buildReflectionEntry(BuildContext context, JournalEntry entry) {
    return GestureDetector(
      onTap: () => _showEntryDetails(context, entry, isReflection: true),
      child: Card(
        color: Colors.teal[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                      DateFormat('h:mm a').format(entry.date!),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildCategorySection(context, entry)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Grateful for:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(entry.gratefulFor, 
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
             
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Thoughts:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(entry.otherThoughts, 
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, JournalEntry entry) {
    final categories = entry.category.split(', ');
    final iconCodes = entry.iconCodes;
    final borderColor = moodEntries.isNotEmpty
        ? moodEntries.first.mood.color
        : Colors.black87;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(categories.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.teal[100],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(IconData(iconCodes[index], fontFamily: 'MaterialIcons'), size: 20,color: borderColor, ),
              const SizedBox(width: 4.0),
              Text(
                categories[index],
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMoodColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16),
          child: const Text(
            'Moods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 111, 39, 236),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (moodEntries.isNotEmpty)
          ...moodEntries.map((entry) => _buildMoodEntry(context, entry))
        else
          _buildNoEntryMessage(context, isReflection: false),
      ],
    );
  }

  Widget _buildMoodEntry(BuildContext context, MoodEntry entry) {
    return GestureDetector(
      onTap: () => _showEntryDetails(context, entry, isReflection: false),
      child: Card(
        color: Colors.deepPurple[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    entry.mood.emojiPath,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.mood.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: entry.mood.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('h:mm a').format(entry.date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: entry.factors.map((factor) {
                  return Chip(
                    label: Text(factor, style: const TextStyle(fontSize: 14)),
                    backgroundColor: Colors.deepPurple[100],
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              if (entry.journal.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Journal: ${entry.journal}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoEntryMessage(BuildContext context, {required bool isReflection}) {
    return Card(
      color: isReflection ? Colors.teal[50] : Colors.deepPurple[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              isReflection ? Icons.text_snippet_outlined : Icons.mood_outlined,
              size: 48,
              color: isReflection ? Colors.teal : Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            Text(isReflection ? 'Take a moment and reflect on your day' : 'No mood entry for this day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isReflection ? Colors.teal[700] : Colors.deepPurple[700],
              ),
              textAlign: TextAlign.center,
           ),
           
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text('Add ${isReflection ? 'Entry' : 'Mood'}'),
              onPressed: onAddEntry,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isReflection ? Colors.teal : Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEntryDetails(BuildContext context, dynamic entry, {required bool isReflection}) {
    showDialog(
      context: context,
      builder: (context) => EntryDetailDialog(
        entry: entry,
        isReflection: isReflection,
        refreshParent: () {},
      ),
    );
  }
}