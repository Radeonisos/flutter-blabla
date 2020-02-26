import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_blabla/Controller/ChatController.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:flutter_blabla/Widget/CustomImage.dart';

class ContactsController extends StatefulWidget {
  String id;

  ContactsController(String id) {
    this.id = id;
  }

  ContactsControllerState createState() => new ContactsControllerState();
}

class ContactsControllerState extends State<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      sort: (a, b) => a.value["prenom"].compareTo(b.value["prenom"]),
      query: FireBaseHelper().base_user,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        User newUser = User(snapshot);
        if (newUser.uid == widget.id) {
          return new Container();
        } else {
          return ListTile(
            leading: CustomImage(newUser.imgUrl, newUser.initial, 20),
            title: Text(" ${newUser.firstName}  ${newUser.lastName}",
                style: TextStyle(color: Constants.colorElement)),
            trailing: IconButton(
              icon: Icon(
                Icons.message,
                color: Constants.colorElement,
              ),
              onPressed: () {
                // go message
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatController(widget.id, newUser)));
              },
            ),
          );
        }
      },
    );
  }
}
