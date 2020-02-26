import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/Message.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:flutter_blabla/Widget/CustomImage.dart';

class ChatBubble extends StatelessWidget {
  Message message;
  User partenaire;
  String monId;
  Animation animation;

  ChatBubble(String id, User partenaire, Message message, Animation animation) {
    this.monId = id;
    this.message = message;
    this.partenaire = partenaire;
    this.animation = animation;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: new Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widgetsBubble(message.from == monId),
        ),
      ),
    );
  }

  List<Widget> widgetsBubble(bool moi) {
    CrossAxisAlignment alignment =
        (moi) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color bubbleColor = (moi) ? Colors.blue[400] : Colors.grey[300];
    Color textColor = (moi) ? Colors.white : Colors.black;
    return <Widget>[
      moi
          ? Padding(
              padding: EdgeInsets.all(8.0),
            )
          : CustomImage(partenaire.imgUrl, partenaire.initial, 15),
      Expanded(
        child: Column(
          crossAxisAlignment: alignment,
          children: <Widget>[
            Text(
              message.time,
              style: TextStyle(color: Constants.colorElementSecondary),
            ),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: bubbleColor,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: (message.imgUrl == null)
                    ? Text(
                        message.text,
                        style: TextStyle(color: textColor),
                      )
                    : CustomImage(message.imgUrl, null, null),
              ),
            )
          ],
        ),
      )
    ];
  }
}
