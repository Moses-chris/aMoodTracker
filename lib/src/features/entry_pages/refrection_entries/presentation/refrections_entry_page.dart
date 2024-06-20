// reflections_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../constants/styling/styles.dart';
import '../../shared/datepicker.dart';
import '../../shared/headertext.dart';
import '../../shared/refrectioninputfield.dart';
import '../data/category_selection_provider.dart';
import '../data/dataentry/refrection_data_entry.dart';
import '../widgets/category_widget.dart';
// Import the journal entry model

class ReflectionsPage extends StatefulWidget {
  const ReflectionsPage({super.key});

  @override
  _ReflectionsPageState createState() => _ReflectionsPageState();
}

class _ReflectionsPageState extends State<ReflectionsPage> {
  final TextEditingController _gratefulController = TextEditingController();
  final TextEditingController _thoughtsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<bool> _showLeaveConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Mystyles.mybackgroundColor,
            title:  Text(
              'Are you sure?',
              style: Mystyles.textstyle.copyWith(fontSize: 20),
              ),
            content:  Text('Leaving without saving will discard all changes.',
                  style: Mystyles.textstyle,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }


  Future<void> _saveEntry() async {
    final selectedItems = context.read<CategorySelectionProvider>().getSelectedItems();
    final selectedIcons = context.read<CategorySelectionProvider>().getSelectedIcons();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select at least one category item.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final gratefulFor = _gratefulController.text.trim();
    final otherThoughts = _thoughtsController.text.trim();

    if (gratefulFor.isEmpty || otherThoughts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final newEntry = JournalEntry(
      category: selectedItems.join(', '),
      gratefulFor: gratefulFor,
      otherThoughts: otherThoughts,
      iconCodes: selectedIcons,
      date: _selectedDate,
    );

    final box = Hive.box<JournalEntry>('journal_entries');
    await box.add(newEntry);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Entry saved successfully!'),
      backgroundColor: Colors.green,
    ));

    Navigator.pushNamed(context, '/view_entries');

    _gratefulController.clear();
    _thoughtsController.clear();
    context.read<CategorySelectionProvider>().clearSelections();
  }

  @override
  Widget build(BuildContext context) {
      // ignore: deprecated_member_use
      return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await _showLeaveConfirmationDialog(context);
        return shouldLeave;
      },
      child: Scaffold(
        backgroundColor: Mystyles.mybackgroundColor,
        body: Column(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        bool shouldLeave = await _showLeaveConfirmationDialog(context);
                        if (shouldLeave) {
                          if (!mounted) return; // Check if the widget is still mounted
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const Spacer(),
                    CustomDatePicker(
                      initialDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed:  () {
                        _saveEntry();
                      }, 
                      icon:const Icon(Icons.add_task_outlined)
                      )
                  ],
                ),
              ),
            ),
            Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderText(text: "What have you been up to"),
                const SizedBox(height: 10),
                CategoryWidget(),
                const SizedBox(height: 10),
                const HeaderText(text: "What are you grateful for today?"),
                const SizedBox(height: 10),
                refrectionInputField(
                  hintText: "I am grateful for ...",
                  controller: _gratefulController,
                ),
                const SizedBox(height: 10),
                const HeaderText(text: "Any Other Thoughts?"),
                const SizedBox(height: 10),
                refrectionInputField(
                  hintText: "Today I learned ...",
                  controller: _thoughtsController,
                ),
                const SizedBox(height: 20),
               
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveEntry,
                  child: const Text('Save Entry'),
                ),
              ],
            ),
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}
