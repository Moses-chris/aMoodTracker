import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import '../shared/datepicker.dart';

class MoodappbarBody extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Future<void> Function() saveEntry;
  final Future<bool> Function(BuildContext context) showLeaveConfirmationDialog;

  const MoodappbarBody({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.saveEntry,
    required this.showLeaveConfirmationDialog,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await showLeaveConfirmationDialog(context);
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
                        bool shouldLeave = await showLeaveConfirmationDialog(context);
                        if (shouldLeave) {
                          if (!context.mounted) return; // Check if the widget is still mounted
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const Spacer(),
                    CustomDatePicker(
                      initialDate: selectedDate,
                      onDateSelected: onDateSelected,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: saveEntry,
                      icon: const Icon(Icons.add_task_outlined),
                    ),
                  ],
                ),
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}
