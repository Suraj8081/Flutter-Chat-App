import 'dart:developer' as dev;
import 'dart:io';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/utils.dart';
import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/chat/chat_bloc.dart';
import 'package:my_chat/provider/chat/chat_event.dart';
import 'package:my_chat/provider/chat/chat_state.dart';
import 'package:my_chat/widget/chat_messages.dart';
import 'package:my_chat/widget/chat_other_option.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.senderProfile});

  final UserProfile senderProfile;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatBloc chatBloc;
  String chatNode = '';
  List<ChatModel> allChats = [];
  late FirebaseOperations firebaseOperations;
  late UserProfile myProfile;

  void setupPushNotification(String chatNode) async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    fcm.subscribeToTopic(chatNode);
  }

  @override
  void initState() {
    super.initState();
    firebaseOperations = FirebaseOperations();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(CreateChatNodeEvent(widget.senderProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatNodeCreatedState) {
          dev.log(state.chatNodeId, name: 'ChatNode');
          chatNode = state.chatNodeId;
          myProfile = state.myProfile;
          setupPushNotification(chatNode);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: getThemeColor(context).primary,
              title: Text(
                widget.senderProfile.name!,
                style: TextStyle(
                    color: getThemeColor(context).onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: firebaseOperations.getAllMsg(chatNode),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            List<ChatModel> chatMessages = [];
                            if (snapshot.hasData) {
                              DataSnapshot dataSnapshot =
                                  snapshot.data!.snapshot;
                              if (dataSnapshot.children.isNotEmpty) {
                                dataSnapshot.children.forEach((element) {
                                  Map<dynamic, dynamic> chatMap =
                                      element.value as Map<dynamic, dynamic>;
                                  ChatModel chat = ChatModel.fromJson(chatMap);
                                  chatMessages.add(chat);
                                });
                              }
                            } else {}
                            List<ChatModel> reversedMsg =
                                chatMessages.reversed.toList();
                            return Expanded(
                              child: ListView.builder(
                                itemCount: reversedMsg.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  ChatModel chat = reversedMsg[index];
                                  return GestureDetector(
                                    key: ValueKey(chat.id),
                                    onLongPressStart: (details) {
                                      _showPopupMenu(context,
                                          details.globalPosition, chat);
                                    },
                                    child: ChatMessages(
                                      chatModel: chat,
                                      myUserId: myProfile.id!,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          // if (snapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const Loading();
                          // }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                MessageBar(
                  onSend: (msg) => _onClickSend(msg, ChatType.text),
                  actions: [
                    InkWell(
                        child: const Icon(
                          Icons.add,
                          color: Colors.green,
                          size: 24,
                        ),
                        onTap: () {
                          chatBloc.add(OtherOptionSendEvent());
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        child: const ImageIcon(
                          AssetImage('assets/images/click_camera.png'),
                          color: Colors.black,
                          size: 24,
                        ),
                        onTap: () {
                          pickImage(ImageSource.camera,
                              (file) => {if (file != null) uploadFile(file)});
                        },
                      ),
                    ),
                  ],
                ),
                if (state is OtherOptionSendState)
                  Visibility(
                    visible: state.isActive,
                    child: Expanded(
                      child: ChatOtherOption(
                        onTap: (chatType) {
                          if (chatType == ChatType.camera) {
                            pickImage(ImageSource.camera,
                                (file) => {if (file != null) uploadFile(file)});
                          }
                          if (chatType == ChatType.gallery) {
                            pickImage(ImageSource.gallery,
                                (file) => {if (file != null) uploadFile(file)});
                          }
                          if (chatType == ChatType.doc) {
                            pickFile((file) {
                              file.map((e) => uploadFile(e));
                            });
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ));
      },
    );
  }

  void _onClickSend(String msg, ChatType chatType) {
    ChatModel chatModel = ChatModel(
      chatTitle: msg,
      time: Timestamp.now().millisecondsSinceEpoch.toString(),
      chatType: chatType,
      sendBy: myProfile.id!,
      isRead: '0',
    );
    chatBloc.add(ChatSendEvent(chatModel, chatNode));
  }

  void uploadFile(File file) async {
    String fileName = Timestamp.now().millisecondsSinceEpoch.toString();
    String url =
        await firebaseOperations.uploadImage(myProfile.id!, fileName, file);
    _onClickSend(url, ChatType.image);
  }

  void _showPopupMenu(
      BuildContext context, Offset offset, ChatModel chatModel) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem(
          child: const Text('Delete'),
          onTap: () {
            firebaseOperations.deleteChat(chatNode, chatModel);
          },
        ),
        PopupMenuItem(
          child: const Text('Edit'),
          onTap: () {},
        ),
      ],
    );
  }
}
