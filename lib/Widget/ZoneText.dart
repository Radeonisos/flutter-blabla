import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:image_picker/image_picker.dart';

class ZoneText extends StatefulWidget {
  User partenaire;
  String id;

  ZoneText(this.partenaire, this.id);

  ZoneTextState createState() => new ZoneTextState();
}

class ZoneTextState extends State<ZoneText> {
  TextEditingController textEditingController = TextEditingController();
  User me;

  @override
  void initState() {
    super.initState();
    FireBaseHelper().getUser(widget.id).then((user) {
      setState(() {
        me = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Constants.colorElementSecondary,
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_enhance),
            onPressed: () => takePicture(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () => takePicture(ImageSource.gallery),
          ),
          Flexible(
            child: TextField(
              controller: textEditingController,
              decoration:
                  InputDecoration.collapsed(hintText: "Votre message ..."),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendButtonPressed,
          )
        ],
      ),
    );
  }

  sendButtonPressed() {
    if (textEditingController.text != null &&
        textEditingController.text != "") {
      String text = textEditingController.text;
      FireBaseHelper().sendMsg(widget.partenaire, me, text, null);
      textEditingController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      print('text vide ou null');
    }
  }

  Future<void> takePicture(ImageSource source) async {
    File file = await ImagePicker.pickImage(
        source: source, maxWidth: 800.0, maxHeight: 800.0);
    String date = new DateTime.now().millisecondsSinceEpoch.toString();
    FireBaseHelper()
        .savePicture(
            file, FireBaseHelper().storage_msg.child(widget.id).child(date))
        .then((string) {
      FireBaseHelper().sendMsg(widget.partenaire, me, null, string);
    });
  }
}
