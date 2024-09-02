import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_chat/model/user_profile.dart';

class FireOperations {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storageBucket = FirebaseStorage.instance.ref();

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

  Future<void> createUser(
      UserProfile userProfile) {
    return _db.collection(Collections.USERS.name).doc(userProfile.id!).set(userProfile.toJson());
  }

  Future<void> updateUser(UserProfile userProfile) {
    return _db
        .collection(Collections.USERS.name)
        .doc(userProfile.id)
        .update(userProfile.toJson());
  }

  // Future<void> updateProfileUser(UserProfile userProfile) {
  //   return _db
  //       .collection(Collections.USERS.name)
  //       .where('emailId', isEqualTo: userProfile.emailId)
  //       .get()
  //       .then(
  //     (querySnapshot) {
  //       if (querySnapshot.docs.isNotEmpty) {
  //         querySnapshot.docs.forEach((element) {
  //           _db
  //               .collection(Collections.USERS.name)
  //               .doc(userProfile.id)
  //               .update(userProfile.toJson());
  //         });
  //       }
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
  // }

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
      log('Upload file:$percentage');
    });
    await task;
    return storageRef.getDownloadURL();
  }

  Future<List<UserProfile>> getAllUser() async {
    List<UserProfile> userProfileList = [];
    await _db.collection(Collections.USERS.name).get().then(
      (querySnapshot) {
        print("Successfully completed");
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
        .collection(Collections.USERS.name)
        .where('emailId', isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          userProfile = UserProfile.fromJson(docSnapshot.data());
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userProfile;
  }
}

enum Collections {
  USERS,
  USERS_IMAGE,
}
