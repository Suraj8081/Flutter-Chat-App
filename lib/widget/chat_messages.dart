import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/widget/show_image_screen.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.chatModel,
    required this.myUserId,
  });

  final ChatModel chatModel;
  final String myUserId;

  @override
  Widget build(BuildContext context) {
    if (chatModel.chatType == ChatType.text) {
      return textUI(chatModel, context, myUserId);
      // return docUI(chatModel, context, myUserId);
    }

    if (chatModel.chatType == ChatType.image) {
      return imageUI(chatModel, context, myUserId);
    }

    return const SizedBox();
  }
}

Widget textUI(ChatModel chatModel, BuildContext context, String myUserId) {
  return BubbleSpecialThree(
    key: ValueKey(chatModel.id!),
    text: chatModel.chatTitle,
    color: chatModel.sendBy == myUserId
        ? getThemeColor(context).primary
        : getThemeColor(context).secondary,
    tail: false,
    textStyle: TextStyle(
        color: chatModel.sendBy == myUserId
            ? getThemeColor(context).onPrimary
            : getThemeColor(context).onSecondary,
        fontSize: 16),
    isSender: chatModel.sendBy == myUserId,
    delivered: true,
    seen: chatModel.isRead == '1',
  );
}

Widget imageUI(ChatModel chatModel, BuildContext context, String myUserId) {
  return SizedBox(
    height: 200,
    child: BubbleNormalImage(
      onTap: () {
        moveTo(context, ShowImageScreen(imageUrl: chatModel.chatTitle));
      },
      key: ValueKey(chatModel.id!),
      id: chatModel.id!,
      image: FadeInImage(
          image: NetworkImage(chatModel.chatTitle),
          placeholder: const AssetImage("assets/images/image_placeholder.png"),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/image_placeholder.png',
              fit: BoxFit.fitWidth,
            );
          },
          fit: BoxFit.fitWidth),
      color: chatModel.sendBy == myUserId
          ? getThemeColor(context).primary
          : getThemeColor(context).secondary,
      tail: false,
      isSender: chatModel.sendBy == myUserId,
      delivered: true,
      seen: chatModel.isRead == '1',
    ),
  );
}

Widget docUI(ChatModel chatModel, BuildContext context, String myUserId) {
  return SizedBox(
    width: 100,
    child: Row(
      children: [
        Image.asset(
          'assets/images/doc.png',
          width: 50,
          height: 50,
        )
      ],
    ),
  );
}
