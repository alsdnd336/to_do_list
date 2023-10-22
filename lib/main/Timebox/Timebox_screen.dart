import 'dart:ffi';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';


class TimeboxScreen extends StatefulWidget {
  const TimeboxScreen({super.key});

  @override
  State<TimeboxScreen> createState() => _TimeboxScreenState();
}

class _TimeboxScreenState extends State<TimeboxScreen> {

  final EventController controller = EventController();
  DateTime now = DateTime.now();

  void addEvent() {

    final DateTime endTime = now.add(const Duration(hours: 2));
    controller.add(
      CalendarEventData(
        date: now,
        event: const Text('hello'),
        title: '클라이언트 미팅',
        description: "Today is project meeting.",
        startTime: now,
        endTime: endTime
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        child: Icon(Icons.edit, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      body: DayView(
        controller: controller,
        eventTileBuilder: (date, events, boundry, start, end) {
          // Return your widget to display as event tile.
            return Container(child: Text(date.toString()),);
        },
        fullDayEventBuilder: (events, date) {
            // Return your widget to display full day event view.
            return Container();
        },
        initialDay: now,
        showVerticalLine: true,
        showLiveTimeLineInAllDays: true,
        heightPerMinute: 1,
        eventArranger: SideEventArranger(),
        onEventTap: (events, date) => print(events),
        onDateLongPress: (date) => print(date),
      ),
    );
  }
}