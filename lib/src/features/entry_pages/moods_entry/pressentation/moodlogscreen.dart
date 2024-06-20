import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/moodlog/mood_entry.dart';
import 'moodrecordgroup.dart';
import 'responsivecenter.dart';
import 'screencontroler.dart';

class MoodRecordsScreen extends ConsumerWidget {
  const MoodRecordsScreen({super.key});

  static void showAddMoodRecordForm(context, MapEntry<dynamic, MoodEntry>? recordToEdit) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => const AddMoodEntryForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(moodRecordScreenControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Log"),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: controller.repository.box.listenable(),
                builder: (context, box, child) {
                  if (controller.repository.box.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Start tracking your mood!",
                            // style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text("Press the '+' button", style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    );
                  } else {
                    final groupedRecords = controller.groupMoodRecordsByDay(box.toMap());

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, kFloatingActionButtonMargin * 2 + 48),
                      itemCount: groupedRecords.length,
                      itemBuilder: (context, index) {
                        final currentGroup = groupedRecords.entries.elementAt(index);
                        return MoodRecordGroup(groupDate: DateTime.parse(currentGroup.key), moodList: currentGroup.value);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddMoodRecordForm(context, null), //context.pushNamed(AppRoute.addRecord.name),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}



class AddMoodEntryForm extends StatefulWidget {
  final MapEntry<dynamic, MoodEntry>? entryToEdit;

  const AddMoodEntryForm({Key? key, this.entryToEdit}) : super(key: key);

  @override
  _AddMoodEntryFormState createState() => _AddMoodEntryFormState();
}

class _AddMoodEntryFormState extends State<AddMoodEntryForm> {
  // Define your state variables and form logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryToEdit == null ? 'Add Mood Entry' : 'Edit Mood Entry'),
      ),
      body: const Center(
        child: Text('Add Mood Entry Form'), // Replace with actual form fields
      ),
    );
  }
}
