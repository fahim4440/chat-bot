import 'package:chat_bot/models/chat_message.dart';
import 'package:chat_bot/services/shared_prefs_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPrefsServices _sharedPrefsServices = SharedPrefsServices();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //MARK:- Auth Related

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception("Google Sign-In canceled");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User user = userCredential.user!;

    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      debugPrint(doc.data().toString());
      UserModel userModel =
          UserModel.fromFirebaseUser(doc.data() as Map<String, dynamic>);
      await _sharedPrefsServices.saveUserInSharedPrefs(userModel);
      return userModel;
    } else {
      await saveUserInfoInFirebase(user);
      UserModel userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          chatGPTKey: null,
          grokAIKey: null,
          geminiAIKey: null);
      await _sharedPrefsServices.saveUserInSharedPrefs(userModel);
      return userModel;
    }
  }

  Future<void> signOut() async {
    await _sharedPrefsServices.deleteUserFromSharedPrefs();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  //MARK:- Database Related

  //MARK:- Profile Related

  Future<UserModel> getUserFromFirebase() async {
    String uid = await _sharedPrefsServices.getUserUidFromSharedPrefs();
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      debugPrint(doc.data().toString());
      UserModel userModel =
          UserModel.fromFirebaseUser(doc.data() as Map<String, dynamic>);
      await _sharedPrefsServices.saveUserInSharedPrefs(userModel);
      return userModel;
    } else {
      throw "User not found!";
    }
  }

  Future<void> saveUserInfoInFirebase(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'chatGPTKey': null,
      'grokAIKey': null,
      'geminiAIKey': null,
    });
  }

  Future<void> updateUserInfoInFirebase(Map<String, String> apiKeys) async {
    String uid = await _sharedPrefsServices.getUserUidFromSharedPrefs();
    await _firestore.collection('users').doc(uid).update(apiKeys);
    await _sharedPrefsServices.updateApiKeyInSharedPrefs(apiKeys);
  }

  //MARK:- Chat Related

  Future<List<ChatMessage>> getChatHistory(String aiName) async {
    String uid = await _sharedPrefsServices.getUserUidFromSharedPrefs();
    final snapshot = await _firestore
        .collection("users")
        .doc(uid)
        .collection("chats")
        .doc(aiName)
        .collection("messages")
        .orderBy("timestamp")
        .get();

    List<ChatMessage> messages = [];

    for (var doc in snapshot.docs) {
      messages.add(ChatMessage(
          userMessage: doc['userMessage'],
          aiResponse: doc['aiResponse'],
          aiName: doc['aiName'],
          timestamp: (doc['timestamp'] as Timestamp?)!.toDate()));
    }

    return messages;
  }

  Future<void> saveMessage(ChatMessage message) async {
    String uid = await _sharedPrefsServices.getUserUidFromSharedPrefs();
    final DocumentReference ref = _firestore
        .collection("users")
        .doc(uid)
        .collection("chats")
        .doc(message.aiName)
        .collection("messages")
        .doc();

    final DocumentReference lastMsgRef = _firestore
        .collection("users")
        .doc(uid)
        .collection("chats")
        .doc(message.aiName);

    await lastMsgRef.set({
      'lastMessage': message.userMessage,
      'lastUpdated': message.timestamp,
    });

    await ref.set({
      "userMessage": message.userMessage,
      "aiResponse": message.aiResponse,
      "aiName": message.aiName,
      "timestamp": message.timestamp,
    });
  }
}
