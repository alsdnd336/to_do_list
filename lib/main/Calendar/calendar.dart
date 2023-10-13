import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/main/Calendar/to_do_list_page.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  
  

  

  @override
  Widget build(BuildContext context) {
    return MonthView(
        onCellTap: (events, date) {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ToDoListPage(date: date, event: null);
          }));
        },
        onEventTap: (event, date) {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ToDoListPage(date: date, event: event);
          }));
        },
    );
  }
}