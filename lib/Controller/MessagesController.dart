import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_blabla/Controller/ChatController.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blabla/Model/Conversation.dart';
import 'package:flutter_blabla/Widget/CustomImage.dart';

class MessagesController extends StatefulWidget {
  String id;

  MessagesController(String id) {
    this.id = id;
  }

  MessagesControllerState createState() => new MessagesControllerState();
}

class MessagesControllerState extends State<MessagesController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FirebaseAnimatedList(
      sort: (a, b) => b.value["time"].compareTo(a.value["time"]),
      query: FireBaseHelper().base_conversation.child(widget.id),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Conversation conversation = new Conversation(snapshot);
        String subTitle = (conversation.id == widget.id) ? "Moi : " : "";
        subTitle += conversation.lastMsg ?? "image envoyée";
        return ListTile(
          leading: CustomImage(
              conversation.user.imgUrl, conversation.user.initial, 20),
          subtitle: Text(
            subTitle,
            style: TextStyle(color: Constants.colorElementSecondary),
          ),
          title: Text(
            "${conversation.user.firstName}  ${conversation.user.lastName}",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Constants.colorElement),
          ),
          trailing: new Text(conversation.date,
              style: TextStyle(color: Constants.colorElementSecondary)),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new ChatController(widget.id, conversation.user)));
          },
        );
      },
    );
  }
}
