import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shcoolapp/%08widgets/calendar_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class CalendarPage extends StatefulWidget {
  int? pk;

  CalendarPage({super.key, this.pk});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Event>> selectedEvents;

  // List<Event> _evloder(DateTime date) {
  //   return selectedEvents[today] ?? [];
  // }

  // @override
  // void initState() {
  //   selectedEvents = {};

  //   super.initState();
  // }

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
  }

  final TextEditingController _eventController = TextEditingController();

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
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
                  builder: (_) => AlertDialog(
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
                                  child: const Text('확인'),
                                  onPressed: () =>
                                      _addEvent(Event(_eventController.text)))
                            ],
                          )
                        ],
                      )),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  // .collection('$pk.$today')
                  .collection(widget.pk.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final documents = snapshot.data!.docs;
                return Expanded(
                  child: Column(
                    children: [
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
                        // eventLoader: _evloder,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '하루 일정',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children:
                              documents.map((doc) => _buildItem(doc)).toList(),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildItem(DocumentSnapshot snapshot) {
    final event = Event(
      snapshot['title'],
    );
    return ListTile(
      title: Text(event.title,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => _deleteEvent(snapshot),
      ),
    );
  }

  void _deleteEvent(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection(widget.pk.toString())
        .doc(snapshot.id)
        .delete();
  }

  void _addEvent(Event event) {
    setState(() {
      FirebaseFirestore.instance
          .collection(widget.pk.toString())
          .add({'title': event.title});
      _eventController.text = "";
    });
  }
}
