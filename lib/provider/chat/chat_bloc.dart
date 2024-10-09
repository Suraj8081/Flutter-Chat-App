import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/firebase_operations.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/provider/chat/chat_event.dart';
import 'package:my_chat/provider/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  FirebaseOperations firebaseOperations = FirebaseOperations();
  LocalRepo localRepo = LocalRepo();
  StreamSubscription? chatReceiveSubscription;
  StreamSubscription? chatEditSubscription;
  StreamSubscription? chatdeleteSubscription;
  bool initChatDataLoaded = false;
  late bool openOtherOption = false;

  ChatBloc() : super(InitialChatState()) {
    on<CreateChatNodeEvent>(_createChatNode);
    on<ChatSendEvent>(_sendMsg);
    on<ChatReceivedEvent>((event, emit) {
      emit(ChatReceivedState(event.chatModel));
    });

    on<ChatEditEvent>((event, emit) {
      emit(ChatEditedState(event.chatModel));
    });

    on<ChatDeleteEvent>((event, emit) {
      emit(ChatDeletedState(event.chatModel));
    });

    on<ChatRefreshEvent>((event, emit) {
      emit(GetAllChatState(event.allMsg));
    });

    on<OtherOptionSendEvent>((event, emit) {
      openOtherOption=!openOtherOption;
      emit(OtherOptionSendState(openOtherOption));
    });
  }

  @override
  Future<void> close() {
    chatReceiveSubscription?.cancel();
    chatEditSubscription?.cancel();
    chatdeleteSubscription?.cancel();
    return super.close();
  }

  void _createChatNode(
      CreateChatNodeEvent event, Emitter<ChatState> emitter) async {
    emitter(ChatLoadingState());
    UserProfile? userProfile = await localRepo.getProfileData();
    if (userProfile != null) {
      String chatNodeId = await firebaseOperations.createChatNode(
          userProfile.id!, event.recevieChatUser.id!);
      emitter(ChatNodeCreatedState(chatNodeId, userProfile));
    }
  }

  void _sendMsg(ChatSendEvent event, Emitter<ChatState> emitter) async {
    UserProfile? userProfile = await localRepo.getProfileData();
    if (userProfile != null) {
      firebaseOperations.sendChat(event.chatModel, event.chatNode,userProfile);
    }
    emitter(ChatSendedState());
  }
}
