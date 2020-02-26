import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blabla/Model/DateHelper.dart';

class Message {
  String from;
  String to;
  String text;
  String imgUrl;
  String time;

  Message(DataSnapshot snapshot) {
    Map value = snapshot.value;
    from = value["from"];
    to = value["to"];
    text = value["text"];
    imgUrl = value["imgUrl"];
    time = value["time"];
    time = DateHepler().getDate(time);
  }
}
