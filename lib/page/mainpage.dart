import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shcoolapp/controller/root_controller.dart';
import 'package:shcoolapp/page/todolist_page.dart';
import '../api/user_api.dart';
import 'boardScreen.dart';
import 'calendarpage.dart';
import 'boardScreen.dart';
import 'chatting_room.dart';

class MainPage extends GetView<RootController> {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(title: const Text('main page')),
          body: IndexedStack(
            index: controller.rootPageIndex.value,
            children: [
              BoardScreen(id: id),
              CalendarPage(),
              TodoPage(),
              ChattingRoom(room: '', name: '')
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.border_all), label: '게시판'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: '캘린더'),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: '투두 리스트'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: '메시지')
            ],
            currentIndex: 0,
            selectedItemColor: Colors.black87,
            onTap: controller.changeRootPageIndex,
          ),
        ));
  }
}
