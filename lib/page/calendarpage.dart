import 'package:flutter/material.dart';
import 'package:shcoolapp/%08widgets/calendar_event.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Event>> selectedEvents;
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
  }

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar',
            style: TextStyle(
                fontFamily: 'salt', color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('events',
                            style: TextStyle(
                                fontFamily: 'salt',
                                color: Colors.black,
                                fontSize: 30)),
                        content: TextFormField(controller: _eventController),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소')),
                              TextButton(
                                  onPressed: () {}, child: const Text('확인'))
                            ],
                          )
                        ],
                      )),
              icon: const Icon(Icons.add))
        ],
      ),
      body: CalendarWidget(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CalendarWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            '선택한 날짜: ${today.toString().split(" ")[0]}',
            style: const TextStyle(
                fontFamily: 'salt', color: Colors.black, fontSize: 30),
          ),
          TableCalendar(
            locale: 'ko_KR',
            daysOfWeekHeight: 20,
            rowHeight: 46,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: ((day) => isSameDay(day, today)),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 10, 16),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsfromDay,
          ),
        ],
      ),
    );
  }
}
