import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../moods_entry/data/moodlog/mood_entry.dart';
import '../refrection_entries/data/dataentry/refrection_data_entry.dart';

class EntryDetailDialog extends StatefulWidget {
  final dynamic entry;
  final bool isReflection;
  final Function refreshParent;
  final int? entryIndex; // Add this line to store the index of the entry

  const EntryDetailDialog({
    Key? key,
    required this.entry,
    required this.isReflection,
    required this.refreshParent,
    this.entryIndex, // Add this line
  }) : super(key: key);

  @override
  _EntryDetailDialogState createState() => _EntryDetailDialogState();
}

class _EntryDetailDialogState extends State<EntryDetailDialog> {
  late TextEditingController _gratefulController;
  late TextEditingController _thoughtsController;
  late TextEditingController _journalController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.isReflection) {
      final reflectionEntry = widget.entry as JournalEntry;
      _gratefulController = TextEditingController(text: reflectionEntry.gratefulFor);
      _thoughtsController = TextEditingController(text: reflectionEntry.otherThoughts);
    } else {
      final moodEntry = widget.entry as MoodEntry;
      _journalController = TextEditingController(text: moodEntry.journal);
    }
  }

  @override
  void dispose() {
    if (widget.isReflection) {
      _gratefulController.dispose();
      _thoughtsController.dispose();
    } else {
      _journalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {

    return Container(
      height: 450,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.isReflection ? Colors.teal[50] : Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
        border: Border.all(
          color: widget.isReflection ? Colors.teal : Colors.deepPurple,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.isReflection ? 'Reflection Details' : 'Mood Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: widget.isReflection ? Colors.teal[700] : Colors.deepPurple[700],
            ),
          ),
        
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: widget.isReflection ? _buildReflectionDetails() : _buildMoodDetails(),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildActionButton(
                context,
                _isEditing ? 'Save' : 'Edit',
                _isEditing ? Icons.save : Icons.edit,
                () => _isEditing ? _saveEntry() : _toggleEdit(),
              ),
              _buildActionButton(
                context,
                'Delete',
                Icons.delete,
                () => _deleteEntry(context),
              ),
              _buildActionButton(
                context,
                'Close',
                Icons.close,
                () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionDetails() {
    final reflectionEntry = widget.entry as JournalEntry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(DateFormat('yyyy-MM-dd').format(reflectionEntry.date!)),
        const SizedBox(height: 10),
        Text('Categories: ${reflectionEntry.category}'),
        const SizedBox(height: 10),
        _isEditing
            ? TextField(
                controller: _gratefulController,
                decoration: const InputDecoration(labelText: 'Grateful for'),
              )
            : Text('Grateful for: ${reflectionEntry.gratefulFor}'),
        const SizedBox(height: 10),
        _isEditing
            ? TextField(
                controller: _thoughtsController,
                decoration: const InputDecoration(labelText: 'Other thoughts'),
              )
            : Text('Other thoughts: ${reflectionEntry.otherThoughts}'),
      ],
    );
  }

  Widget _buildMoodDetails() {
    final moodEntry = widget.entry as MoodEntry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(' ${DateFormat('yyyy-MM-dd HH:mm').format(moodEntry.date)}'),
        const SizedBox(height: 10),
        Row(
          children: [
            Image.asset(moodEntry.mood.emojiPath, width: 50, height: 50),
            const SizedBox(width: 10),
            Text(
              ' ${moodEntry.mood.text}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: moodEntry.mood.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Factors: ${moodEntry.factors.join(", ")}'),
        const SizedBox(height: 16),
        _isEditing
            ? TextField(
                controller: _journalController,
                decoration: const InputDecoration(labelText: 'Journal'),
              )
            : Text('Journal: ${moodEntry.journal}'),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: widget.isReflection ? Colors.teal : Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveEntry() async {
    try {
      if (widget.isReflection) {
        final reflectionEntry = widget.entry as JournalEntry;
        reflectionEntry.gratefulFor = _gratefulController.text;
        reflectionEntry.otherThoughts = _thoughtsController.text;
        
        final box = await Hive.openBox<JournalEntry>('journal_entries');
        if (reflectionEntry.isInBox) {
          // If the entry is already in the box, just save it
          await reflectionEntry.save();
        } else {
          // If it's a new entry, add it to the box
          await box.add(reflectionEntry);
        }
      } else {
        final moodEntry = widget.entry as MoodEntry;
        moodEntry.journal = _journalController.text;
        
        final box = await Hive.openBox<MoodEntry>('moodEntries');
        if (moodEntry.isInBox) {
          // If the entry is already in the box, just save it
          await moodEntry.save();
        } else {
          // If it's a new entry, add it to the box
          await box.add(moodEntry);
        }
      }
      
      setState(() {
        _isEditing = false;
      });
      
      widget.refreshParent();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved successfully')),
      );
    } catch (e) {
      print('Error saving entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save entry: $e')),
      );
    }
  }


void _deleteEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFC9FAD),
          title: const Text(
            'Confirm Delete',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this entry?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color.fromARGB(255, 192, 219, 241),
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color.fromARGB(141, 244, 86, 75),
                ),
              ),
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  if (widget.isReflection) {
                    final box = await Hive.openBox<JournalEntry>('journal_entries');
                    if (widget.entryIndex != null) {
                      await box.deleteAt(widget.entryIndex!);
                    } else {
                      // If index is not available, try to delete by value
                      await box.delete(widget.entry.key);
                    }
                  } else {
                    final box = await Hive.openBox<MoodEntry>('moodEntries');
                    await box.delete(widget.entry.key);
                  }
                  widget.refreshParent();
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close detail dialog
                } catch (e) {
                  print('Error deleting entry: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete entry: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

}