import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

List<CalendarEvent> sampleEvents() {
  final today = DateTime.now();
  final events = [
    CalendarEvent(
      eventName: "Meeting with Bob",
      eventDate: today,
      eventTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    // CalendarEvent(
    //   eventName: "Dentist Appointment",
    //   eventDate: today.add(Duration(days: 1)),
    //   eventTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // CalendarEvent(
    //   eventName: "Lunch with Alice",
    //   eventDate: today.add(Duration(days: 2)),
    //   eventTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // CalendarEvent(
    //   eventName: "Conference",
    //   eventDate: today.add(Duration(days: 3)),
    //   eventTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // CalendarEvent(
    //   eventName: "Gym",
    //   eventDate: today.add(Duration(days: 4)),
    //   eventTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
  ];

  return events;
}
