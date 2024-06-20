import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Appointment> _events = []; // Empty events list initially
  final CalendarController _calendarController = CalendarController();
  final Random _random = Random();

  DateTime? _selectedDate;

  void _addEvent(Appointment event) {
    setState(() {
      _events.add(event);
    });
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final calendarHeight = screenHeight * 0.70;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: double.infinity,
                        height: calendarHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF030B4B),
                          border: Border.all(
                            color: const Color(0xFFF205C7),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        child: Stack(
                          children: [
                            SfCalendar(
                              controller: _calendarController,
                              view: _calendarController.view ?? CalendarView.month,
                              todayHighlightColor: const Color(0xFF7CF47C),
                              backgroundColor: const Color(0xFF030B4B),
                              selectionDecoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: const Color(0xFFFC2AEC), width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              headerStyle: const CalendarHeaderStyle(
                                textAlign: TextAlign.center,
                                backgroundColor: Color(0xFF030B4B),
                                textStyle: TextStyle(
                                  color: Color(0xFFF9CFF2),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              viewHeaderStyle: const ViewHeaderStyle(
                                backgroundColor: Color(0xFF030B4B),
                                dayTextStyle: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              monthViewSettings: const MonthViewSettings(
                                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                                dayFormat: 'EEE',
                                numberOfWeeksInView: 6,
                                showTrailingAndLeadingDates: false,
                                monthCellStyle: MonthCellStyle(
                                  backgroundColor: Color(0xFF030B4B),
                                 
                                  trailingDatesBackgroundColor: Colors.transparent,
                                  leadingDatesBackgroundColor: Colors.transparent,
                                  textStyle: TextStyle(
                                    color: Color(0xFFFC2AEC),
                                  ),
                                ),
                              ),
                              timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 8,
                                endHour: 18,
                                timeInterval: Duration(minutes: 30),
                                timeFormat: 'h:mm a',
                                timeTextStyle: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 12,
                                ),
                              ),
                              dataSource: EventDataSource(_events),
                             onTap: (calendarTapDetails) {
                                if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
                                  if (_calendarController.view == CalendarView.week) {
                                    setState(() {
                                      _selectedDate = calendarTapDetails.date;
                                    });
                                  } else {
                                    final selectedDate = calendarTapDetails.date!;
                                    final eventsOnTheDate = _events.where((event) {
                                      final eventDate = event.startTime;
                                      return eventDate.year == selectedDate.year &&
                                          eventDate.month == selectedDate.month &&
                                          eventDate.day == selectedDate.day;
                                    }).toList();
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("${selectedDate.month.monthName} ${selectedDate.day}"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: eventsOnTheDate
                                              .map(
                                                (event) => Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(4),
                                                  margin: const EdgeInsets.only(bottom: 12),
                                                  color: event.color,
                                                  child: Text(
                                                    event.subject,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  }
                                }else if(calendarTapDetails.targetElement == CalendarElement.viewHeader){
                                  setState(() {
                                    _selectedDate = calendarTapDetails.date;
                                    _calendarController.displayDate= _selectedDate!;
                                  });
                                }
                              },
                              
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFF9CFF2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _calendarController.view = CalendarView.week;
                                      if (_selectedDate != null) {
                                             _calendarController.displayDate = _selectedDate!;
                                          }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43125F),
              ),
              onPressed: () {
                // Add a new event
                _showAddEventDialog(context);
              },
              child: const Text(
                'Add Event',
                style: TextStyle(
                  color: Color(0xFFFC2AEC),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/timetable'); // Navigate to the TimeTable screen
              },
              child: const Text('View Time Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final eventNameController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Event"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: eventNameController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Add"),
                  onPressed: () {
                    final event = Appointment(
                      startTime: selectedDate,
                      endTime: selectedDate.add(const Duration(hours: 1)),
                      subject: eventNameController.text,
                      color: _getRandomColor(),
                      startTimeZone: '',
                      endTimeZone: '',
                    );
                    _addEvent(event);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}

extension MonthName on int {
  String get monthName {
    switch (this) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
