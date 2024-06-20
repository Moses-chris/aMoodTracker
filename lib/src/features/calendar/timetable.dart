import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Map<String, String>> timetable = [
    {'subject': 'Mathematics', 'time': '9:00 AM - 10:30 AM'},
    {'subject': 'Physics', 'time': '11:00 AM - 12:30 PM'},
    {'subject': 'Break', 'time': '12:30 PM - 1:30 PM'},
    {'subject': 'Chemistry', 'time': '1:30 PM - 3:00 PM'},
    {'subject': 'Biology', 'time': '3:30 PM - 5:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Table'),
      ),
      body: ListView.builder(
        itemCount: timetable.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(timetable[index]['subject']!),
              subtitle: Text(timetable[index]['time']!),
            ),
          );
        },
      ),
    );
  }
}