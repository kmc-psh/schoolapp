import 'package:flutter/material.dart';
import 'package:shcoolapp/page/todolist_page.dart';
import '../api/user_api.dart';
import 'boardScreen.dart';
import 'calendarpage.dart';
import 'boardScreen.dart';
import 'chatting_room.dart';

// class MainPage extends GetView<RootController> {
//   const MainPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//           body: IndexedStack(
//             index: controller.rootPageIndex.value,
//             children: [
//               BoardScreen(id: id),
//               CalendarPage(),
//               TodoPage(),
//               ChattingRoom(room: '', name: '')
//             ],
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.border_all), label: '게시판'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.calendar_month), label: '캘린더'),
//               BottomNavigationBarItem(icon: Icon(Icons.list), label: '투두 리스트'),
//               BottomNavigationBarItem(icon: Icon(Icons.chat), label: '메시지')
//             ],
//             currentIndex: 0,
//             selectedItemColor: Colors.black87,
//             onTap: controller.changeRootPageIndex,
//           ),
//         ));
//   }
// }
class MainPage extends StatefulWidget {
  String? name;
  String? email;
  int? pk;
  MainPage({required this.name, this.email, this.pk, Key? key})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      BoardScreen(
        id: '',
      ),
      CalendarPage(pk: widget.pk),
      TodoPage(),
      ChattingRoom(
        room: '',
        name: widget.name,
        email: widget.email,
        pk: widget.pk,
      )
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        // selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.grey),
            label: "캘린더",
            activeIcon: Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.grey),
            label: "todolist",
            activeIcon: Icon(
              Icons.list,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.grey),
            label: "chat",
            activeIcon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }
}
