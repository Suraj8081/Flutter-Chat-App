import 'package:flutter/material.dart';
import 'package:my_chat/model/chat_model.dart';

class ChatOtherOption extends StatelessWidget {
  ChatOtherOption({super.key, required this.onTap});

  final Function(ChatType chatType) onTap;

  final optionItemList = ['photo_camera.png', 'gallery.png', 'doc.png'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
      ),
      itemCount: optionItemList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            switch (index) {
              case 0:
                onTap(ChatType.camera);
                break;
              case 1:
                onTap(ChatType.gallery);
              case 2:
                onTap(ChatType.doc);
                break;
              default:
                break;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/${optionItemList[index]}',
              ),
            ),
          ),
        );
      },
    );
  }
}
