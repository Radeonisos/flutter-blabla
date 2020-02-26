import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:flutter_blabla/Model/Message.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:flutter_blabla/Widget/ChatBubble.dart';
import 'package:flutter_blabla/Widget/CustomImage.dart';
import 'package:flutter_blabla/Widget/ZoneText.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ChatController extends StatefulWidget {
  String id;
  User partenaire;

  ChatController(this.id, this.partenaire);

  ChatControllerState createState() => new ChatControllerState();
}

class ChatControllerState extends State<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColorDark,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Don't show the leading button
        backgroundColor: Constants.backgroundColorDark,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            CustomImage(
                widget.partenaire.imgUrl, widget.partenaire.initial, 15.0),
            Container(
              width: 10,
            ),
            Text(widget.partenaire.firstName)
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        child: InkWell(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: <Widget>[
              //zone de chat
              new Flexible(
                  child: FirebaseAnimatedList(
                reverse: true,
                sort: (a, b) => b.key.compareTo(a.key),
                query: FireBaseHelper().base_msg.child(FireBaseHelper()
                    .getMsgRef(widget.id, widget.partenaire.uid)),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Message message = Message(snapshot);
                  return new ChatBubble(
                      widget.id, widget.partenaire, message, animation);
                },
              )),
              //divider
              Divider(
                height: 1.5,
              ),
              //zone de text
              ZoneText(widget.partenaire, widget.id)
            ],
          ),
        ),
      ),
    );
  }
}
