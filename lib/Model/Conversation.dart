import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blabla/Model/DateHelper.dart';
import 'package:flutter_blabla/Model/User.dart';

class Conversation {
  String id;
  String lastMsg;
  String date;

  User user;

  Conversation(DataSnapshot snapshot) {
    this.id = snapshot.value["monId"];
    this.lastMsg = snapshot.value["lastMsg"];
    this.date = snapshot.value["time"];
    this.date = DateHepler().getDate(this.date);
    user = new User(snapshot);
  }
}
