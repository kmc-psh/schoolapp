import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shcoolapp/utils/chatmessage.dart';
import 'package:provider/provider.dart';
import '../model/chatting_model.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  // 애니메이션 키 생성(_animListKey안에 AnimatedListState즉 애니메이션 리스트 안의 상태를 가지고 있다.)
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  // 텍스트 전송
  TextEditingController _textEditingController = TextEditingController();

  // 변수 생성
  List<String> _chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chatting'),
      ),
      body: Column(
        children: [
          // 바디를 열로 묶고 그안에 익스펜디드로 리스트뷰를 묶은 다음 로우로 채팅 메시지를
          // 만들었기 때문에 위에는 리스트뷰가 먼저 실행되고 채팅 메시지 바는 밑에 자리잡는다.
          // 그리고 익스펜디드로 묶었기 때문에 채팅 메시지 바를 제외한 나머지 부분을 차지한다.
          Expanded(
              child: AnimatedList(
            // 키 설정
            key: _animListKey,
            // 리버스를 사용하여 채팅 메시지가 아래에 붙게 만들었다. (맨 아래부터 채팅메시지가 쌓이는 구조 but 새로운 채팅 메시지는 맨아래로 와야 되므로,
            // 밑에 _chats.insert(0, newChat)을 사용함)
            reverse: true,

            // 아이템 빌더에서 모든 파라미터를 _buildItem으로 던져준다.
            itemBuilder: _buildItem,
          )),
          Divider(
            thickness: 0.5,
            height: 3,
            color: Colors.grey,
          ),
          Container(
            // 채팅 필드 박스 크기를 제한하여 메시지가 일정 이상이 되면 아래로 내려간다.
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .5),
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                // Expanded는 사이즈 고정 + row column에서만 사용
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration:
                        const InputDecoration(hintText: "Send a Message"),
                    // onSubmitted는 _handleSubmitted와 같이 (String text) 구조로 이루어져 있으므로
                    // onSubmitted: _handleSubmitted,처럼 바로 묶어주면 된다.
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _handleSubmitted(_textEditingController.text);
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 위젯을 가지고 오는 메서드 생성
  Widget _buildItem(context, index, animation) {
    return ChatMessage(_chats[index], animation: animation);
  }

  // 전송 버튼 2가지를 하나로 묶어준다.
  void _handleSubmitted(String text) {
    // 로그 남기기
    Logger().d(text);
    //setState는 StatefulWidget안의 State에서 사용되는데, setState가 실행될 때마다 StatefulWidget에게 바뀐 위젯 상태에 따라
    //다시 빌드하라고 알려준다.애니메이트 리스트를 사용할 경우 setState를 사용할 필요가 없다.
    _textEditingController.clear();
    _chats.insert(0, text);

    // 0번째의 텍스트가 새로 생길때마다 상태가 바꼈다고 애니메이트 리스트에 알려준다.
    _animListKey.currentState!.insertItem(0);
  }
}
