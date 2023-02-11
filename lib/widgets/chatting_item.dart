import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shcoolapp/model/chatting_model.dart';

import 'package:flutter/material.dart';
import 'package:shcoolapp/page/chattingpage.dart';

import '../provider/chattingProvider.dart';

class ChattingItem extends StatelessWidget {
  const ChattingItem({super.key, required this.chattingModel});
  final ChattingModel chattingModel;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
