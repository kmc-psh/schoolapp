import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  // 변수를 txt로 받아와서 이부분을 메시지로 사용
  final String txt;

  // 애니메이션 변수 생성
  final Animation<double> animation;
  final String id;
  const ChatMessage(this.txt, this.id, {required this.animation, super.key});

  @override
  Widget build(BuildContext context) {
    // 로우로 묶어주고 로우안에 컬럼을 넣어준다.
    return Padding(
      // 패딩의 symmetric에는 수평 수직 범위를 지정해준다
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: FadeTransition(
        // 애니메이션이 흐리다가 점차 밝아짐
        opacity: animation,
        child: SizeTransition(
          // axisAlignment -1로 설정시 애니메이션이 아래에서 올라온다.
          sizeFactor: animation,
          axisAlignment: -1,
          child: Row(
            children: [
              const CircleAvatar(
                child: Text('d'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // txt에 들어있는 정보를 보여준다.
                    Text(txt)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
