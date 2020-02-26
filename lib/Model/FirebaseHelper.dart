import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseHelper {
  final auth = FirebaseAuth.instance;

  // Authentification
  Future<FirebaseUser> handleSignIn(String mail, String password) async {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: mail, password: password);
    final FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> handleCreate(
      String mail, String password, String firstName, String lastName) async {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: mail, password: password);
    final FirebaseUser user = result.user;
    String uid = user.uid;
    Map<String, String> map = {
      "uid": uid,
      "prenom": firstName,
      "nom": lastName
    };
    addUser(uid, map);
    return user;
  }

  Future<bool> handleLogout() async {
    await auth.signOut();
    return true;
  }

  Future<String> myId() async {
    FirebaseUser user = await auth.currentUser();
    return user.uid;
  }

  // DataBase

  static final base = FirebaseDatabase.instance.reference();
  final base_user = base.child("users");
  final base_msg = base.child("msg");
  final base_conversation = base.child("conversation");

  addUser(String uid, Map map) {
    base_user.child(uid).set(map);
  }

  Future<User> getUser(String uid) async {
    DataSnapshot snapshot = await base_user.child(uid).once();
    return new User(snapshot);
  }

  sendMsg(User user, User me, String text, String imgUrl) {
    String date = new DateTime.now().millisecondsSinceEpoch.toString();
    Map map = {
      "from": me.uid,
      "to": user.uid,
      "text": text,
      "imgUrl": imgUrl,
      "time": new DateTime.now().millisecondsSinceEpoch.toString()
    };
    base_msg.child(getMsgRef(me.uid, user.uid)).child(date).set(map);
    base_conversation
        .child(me.uid)
        .child(user.uid)
        .set(getConversation(me.uid, user, text, date));
    base_conversation
        .child(user.uid)
        .child(me.uid)
        .set(getConversation(me.uid, me, text, date));
  }

  Map getConversation(
      String sender, User user, String text, String dateString) {
    Map map = user.toMap();
    map["monId"] = sender;
    map["lastMsg"] = text;
    map["time"] = dateString;
    return map;
  }

  String getMsgRef(String from, String to) {
    String resultat = "";
    List<String> list = [from, to];
    list.sort((a, b) => a.compareTo(b));
    for (var x in list) {
      resultat += x + "+";
    }
    return resultat;
  }

  //Storage
  static final base_storage = FirebaseStorage.instance.ref();
  final StorageReference storage_users = base_storage.child("users");
  final StorageReference storage_msg = base_storage.child("messages");

  Future<String> savePicture(
      File file, StorageReference storageReference) async {
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
