import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shcoolapp/%08widgets/calendar_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var pk = const Uuid().v1();

  late Map<DateTime, List<Event>> selectedEvents;
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
  }

  final TextEditingController _eventController = TextEditingController();

  // @override
  // void initState() {
  //   selectedEvents = {};
  //   super.initState();
  // }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  // List<Event> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }

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
                              // TextButton(
                              //     onPressed: () => Navigator.pop(context),
                              //     child: const Text('취소')),
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () =>
                                    _addEvent(Event(_eventController.text)),
                                // onPressed: () {
                                //   if (_eventController.text.isEmpty) {
                                //   } else {
                                //     if (selectedEvents[_onDaySelected] !=
                                //         null) {
                                //       selectedEvents[today]!.add(
                                //           Event(title: _eventController.text));
                                //     } else {
                                //       selectedEvents[today] = [
                                //         Event(title: _eventController.text)
                                //       ];
                                //     }
                                //   }
                                //   Navigator.pop(context);
                                //   _eventController.clear();
                                //   setState(() {});
                                //   return;
                                // },
                              )
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
                  .collection('$pk.$today')
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
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView(
                          children:
                              documents.map((doc) => _buildItem(doc)).toList(),
                        ),
                      ),
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
      title: Text(
        event.title,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => _deleteEvent(snapshot),
      ),
    );
  }

  void _deleteEvent(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('$pk.$today')
        .doc(snapshot.id)
        .delete();
  }

  void _addEvent(Event event) {
    setState(() {
      FirebaseFirestore.instance
          .collection('$pk.$today')
          .add({'title': event.title});
      _eventController.text = "";
    });
  }

  // ignore: non_constant_identifier_names
  // Widget CalendarWidget() {
  //   StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('$pk.$today').snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const CircularProgressIndicator();
  //         }
  //         final documents = snapshot.data!.docs;

  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: [
  //               Text(
  //                 '선택한 날짜: ${today.toString().split(" ")[0]}',
  //                 style: const TextStyle(
  //                     fontFamily: 'salt', color: Colors.black, fontSize: 30),
  //               ),
  //               Column(children: [
  //                 TableCalendar(
  //                   locale: 'ko_KR',
  //                   daysOfWeekHeight: 20,
  //                   rowHeight: 46,
  //                   headerStyle: const HeaderStyle(
  //                       formatButtonVisible: false, titleCentered: true),
  //                   availableGestures: AvailableGestures.all,
  //                   selectedDayPredicate: ((day) => isSameDay(day, today)),
  //                   focusedDay: today,
  //                   firstDay: DateTime.utc(2010, 10, 16),
  //                   lastDay: DateTime.utc(2030, 10, 16),
  //                   onDaySelected: _onDaySelected,
  //                 ),
  //                 Expanded(
  //                   child: ListView(
  //                     children:
  //                         documents.map((doc) => _buildItem(doc)).toList(),
  //                   ),
  //                 )
  //               ]),
  //             ],
  //           ),
  //         );
  //       });
  // return Padding(
  //   padding: const EdgeInsets.all(10.0),
  //   child: Column(
  //     children: [
  //       Text(
  //         '선택한 날짜: ${today.toString().split(" ")[0]}',
  //         style: const TextStyle(
  //             fontFamily: 'salt', color: Colors.black, fontSize: 30),
  //       ),
  //       Column(
  //         children: [
  //           TableCalendar(
  //             locale: 'ko_KR',
  //             daysOfWeekHeight: 20,
  //             rowHeight: 46,
  //             headerStyle: const HeaderStyle(
  //                 formatButtonVisible: false, titleCentered: true),
  //             availableGestures: AvailableGestures.all,
  //             selectedDayPredicate: ((day) => isSameDay(day, today)),
  //             focusedDay: today,
  //             firstDay: DateTime.utc(2010, 10, 16),
  //             lastDay: DateTime.utc(2030, 10, 16),
  //             onDaySelected: _onDaySelected,
  //             // eventLoader: _getEventsfromDay,
  //           ),
  //           // StreamBuilder<QuerySnapshot>(
  //           //     stream: FirebaseFirestore.instance
  //           //         .collection('$pk.$today')
  //           //         .snapshots(),
  //           //     builder: (context, snapshot) {
  //           //       if (!snapshot.hasData) {
  //           //         return const CircularProgressIndicator();
  //           //       }
  //           //       final documents = snapshot.data!.docs;
  //           //       return Expanded(
  //           //         child: ListView(
  //           //           children:
  //           //               documents.map((doc) => _buildItem(doc)).toList(),
  //           //         ),
  //           //       );
  //           //     }),
  //           // ..._getEventsfromDay(today).map((Event event) => ListTile(
  //           //       title: Text(event.title),
  //           //     ))
  //         ],
  //       ),
  //     ],
  //   ),
  // );
}

  // Widget _buildItem(DocumentSnapshot snapshot) {
  //   final event = Event(
  //     snapshot['title'],
  //   );
  //   return ListTile(
  //     title: Text(
  //       event.title,
  //     ),
  //     trailing: IconButton(
  //       icon: const Icon(Icons.delete_forever),
  //       onPressed: () => _deleteEvent(snapshot),
  //     ),
  //   );
  // }

  // void _deleteEvent(DocumentSnapshot snapshot) {
  //   FirebaseFirestore.instance
  //       .collection('$pk.$today')
  //       .doc(snapshot.id)
  //       .delete();
  // }

  // void _addEvent(Event event) {
  //   setState(() {
  //     FirebaseFirestore.instance
  //         .collection('$pk.$today')
  //         .add({'title': event.title});
  //     _eventController.text = "";
  //   });
  // }
// }
