import 'dart:developer' as dev;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_chat/helper/local_repo.dart';
import 'package:my_chat/model/chat_model.dart';
import 'package:my_chat/model/user_profile.dart';
import 'package:my_chat/network/send_notification_helper.dart';

class FirebaseOperations {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseDatabase _chatDb = FirebaseDatabase.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  final _storageBucket = FirebaseStorage.instance.ref();
  final LocalRepo localRepo = LocalRepo();
  final SendNotificationHelper sendNotification = SendNotificationHelper();

  Future<UserCredential> authenticateUser(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginUser(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUser(UserProfile userProfile) {
    return _db
        .collection(Collections.users.name)
        .doc(userProfile.id!)
        .set(userProfile.toJson());
  }

  Future<void> updateUser(UserProfile userProfile) {
    return _db
        .collection(Collections.users.name)
        .doc(userProfile.id)
        .update(userProfile.toJson());
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Future<String> uploadImage(
      String bucketName, String fileName, File file) async {
    final storageRef = _storageBucket.child(bucketName).child('$fileName.jpg');
    UploadTask task = storageRef.putFile(file);
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      int percentage = progress is int ? (progress * 100).round() : 0;
      dev.log('Upload file:$percentage');
    });
    await task;
    return storageRef.getDownloadURL();
  }

  Future<List<UserProfile>> getAllUser() async {
    List<UserProfile> userProfileList = [];
    await _db.collection(Collections.users.name).get().then(
      (querySnapshot) {
        dev.log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          userProfileList.add(UserProfile.fromJson(docSnapshot.data()));
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userProfileList;
  }

  Future<UserProfile?> getUser(String email) async {
    UserProfile? userProfile;
    await _db
        .collection(Collections.users.name)
        .where('emailId', isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        dev.log("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          userProfile = UserProfile.fromJson(docSnapshot.data());
        }
      },
      onError: (e) => dev.log("Error completing: $e"),
    );
    return userProfile;
  }

////////////////////////////////////////Chat Methods/////////////////////////////////////

  Future<String> createChatNode(String senderId, String receiverId) async {
    DatabaseReference chatsRef = _chatDb.ref().child(Collections.chats.name);

    bool memberExists = false;
    String chatNodeId = '';

    DataSnapshot snapshot = await chatsRef.get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic> chats = snapshot.value as Map<dynamic, dynamic>;

      chats.forEach((chatId, chatData) {
        List<dynamic> members = chatData['members'];

        if (members.contains(senderId) && members.contains(receiverId)) {
          memberExists = true;
          chatNodeId = chatId;
        }
      });
    }

    if (!memberExists) {
      chatNodeId = chatsRef.push().key!;
      chatsRef.child(chatNodeId).update({
        'members': [senderId, receiverId],
      });
    }

    return chatNodeId;
  }

  void sendChat(ChatModel chatModel, String chatNode, UserProfile userProfile) {
    DatabaseReference chatNodeRef =
        _chatDb.ref().child(Collections.chatMessages.name).child(chatNode);
    String? msgId = chatNodeRef.push().key;
    ChatModel chat = chatModel.copyWith(id: msgId);
    chatNodeRef.child(msgId!).update(chat.toJson());
    sendNotification.sendNotification(chatModel, chatNode, userProfile);
  }

  Stream<DatabaseEvent> getAllMsg(String chatNode) {
    return _chatDb
        .ref()
        .child(Collections.chatMessages.name)
        .child(chatNode)
        .orderByChild('time')
        .onValue;
  }

  void deleteChat(String chatNode, ChatModel chatModel) async {
    await _chatDb
        .ref()
        .child(Collections.chatMessages.name)
        .child(chatNode)
        .child(chatModel.id!)
        .remove();
  }

  void editChat(String chatNode, ChatModel chatModel) async {
    await _chatDb
        .ref()
        .child(Collections.chatMessages.name)
        .child(chatNode)
        .child(chatModel.id!)
        .set(chatModel.toJson());
  }

  Future<void> unsubscibeAllNode(String senderId) async {
    DatabaseReference chatsRef = _chatDb.ref().child(Collections.chats.name);

    DataSnapshot snapshot = await chatsRef.get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic> chats = snapshot.value as Map<dynamic, dynamic>;

      chats.forEach((chatId, chatData) {
        List<dynamic> members = chatData['members'];

        if (members.contains(senderId)) {
          fcm.unsubscribeFromTopic(chatId);
          dev.log('unsubscribe topic and chat id:$chatId',name: 'unsubscribe topic');
        }
      });
    }
  }

  Future<void> subscibeAllNode(String senderId) async {
    DatabaseReference chatsRef = _chatDb.ref().child(Collections.chats.name);

    DataSnapshot snapshot = await chatsRef.get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic> chats = snapshot.value as Map<dynamic, dynamic>;

      chats.forEach((chatId, chatData) {
        List<dynamic> members = chatData['members'];

        if (members.contains(senderId)) {
          fcm.subscribeToTopic(chatId);
          dev.log('subscribe topic and chat id:$chatId',name: 'subscribe topic');
        }
      });
    }
  }

  void subscibeNode(String nodeId) {
    fcm.subscribeToTopic(nodeId);
  }
}

enum Collections { users, usersImage, chats, chatMessages }
