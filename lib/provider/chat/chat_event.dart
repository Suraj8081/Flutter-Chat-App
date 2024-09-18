import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/model/user_profile.dart';

abstract class ChatEvent {}

class ChatSendEvent extends ChatEvent {
  ChatModel chatModel;
  String chatNode;

  ChatSendEvent(this.chatModel, this.chatNode);
}

class ChatReceivedEvent extends ChatEvent {
  ChatModel chatModel;

  ChatReceivedEvent(this.chatModel);
}

class ChatDeleteEvent extends ChatEvent {
  ChatModel chatModel;

  ChatDeleteEvent(this.chatModel);
}

class ChatEditEvent extends ChatEvent {
  ChatModel chatModel;

  ChatEditEvent(this.chatModel);
}

class CreateChatNodeEvent extends ChatEvent {
  UserProfile recevieChatUser;

  CreateChatNodeEvent(this.recevieChatUser);
}

class ChatListenEvent extends ChatEvent {
  String chatNode;

  ChatListenEvent(this.chatNode);
}

class ChatRefreshEvent extends ChatEvent {
  List<ChatModel> allMsg;

  ChatRefreshEvent(this.allMsg);
}

class OtherOptionSendEvent extends ChatEvent {
  // final bool isActive;

  OtherOptionSendEvent();
}
