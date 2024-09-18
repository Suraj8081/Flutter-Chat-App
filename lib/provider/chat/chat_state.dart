import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/model/user_profile.dart';

abstract class ChatState {}

class InitialChatState extends ChatState {}

class ChatSendedState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatReceivedState extends ChatState {
  ChatModel receviedChat;

  ChatReceivedState(this.receviedChat);
}

class ChatDeletedState extends ChatState {
  ChatModel deleteChat;

  ChatDeletedState(this.deleteChat);
}

class ChatEditedState extends ChatState {
  ChatModel editChat;

  ChatEditedState(this.editChat);
}

class GetAllChatState extends ChatState {
  List<ChatModel> allMsg;

  GetAllChatState(this.allMsg);
}

class ChatNodeCreatedState extends ChatState {
  String chatNodeId;
  UserProfile myProfile;

  ChatNodeCreatedState(this.chatNodeId, this.myProfile);
}

class OtherOptionSendState extends ChatState {
  final bool isActive;

  OtherOptionSendState(this.isActive);
}
