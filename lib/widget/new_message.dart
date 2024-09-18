import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/chat/chat_bloc.dart';
import 'package:my_chat/provider/chat/chat_event.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({
    super.key,
    required this.chatBloc,
    required this.senderUser,
    required this.chatNode,
  });

  final ChatBloc chatBloc;
  final UserProfile senderUser;
  final String chatNode;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _onClickSend(String msg) {
    if (widget.chatNode.isEmpty) {
      showSnackBar(
        context,
        'Chat Node is empty',
        bgColor: Colors.red[700],
      );
    } else if (msg.isNotEmpty) {
      ChatModel chatModel = ChatModel(
        chatTitle: msg,
        time: Timestamp.now().millisecondsSinceEpoch.toString(),
        chatType: ChatType.text,
        sendBy: widget.senderUser.id!,
        isRead: '0',
      );
      FocusScope.of(context).unfocus();
      _msgController.clear();
      widget.chatBloc.add(ChatSendEvent(chatModel, widget.chatNode));
    } else {
      showSnackBar(
        context,
        'Message is empty',
        bgColor: Colors.red[700],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                controller: _msgController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  hintText: 'Send Messages...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _onClickSend(_msgController.text);
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
