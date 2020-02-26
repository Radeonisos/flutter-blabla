import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:flutter_blabla/Model/User.dart';
import 'package:flutter_blabla/Widget/CustomImage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilController extends StatefulWidget {
  String id;

  ProfilController(String id) {
    this.id = id;
  }

  ProfilControllerState createState() => new ProfilControllerState();
}

class ProfilControllerState extends State<ProfilController> {
  User user;
  String firstName;
  String lastName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? Center(
            child: Text(
              "Chargement ...",
              style: TextStyle(color: Constants.colorElement),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Image
                  new CustomImage(user.imgUrl, user.initial,
                      MediaQuery.of(context).size.width / 5),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_enhance,
                            color: Constants.colorElement),
                        onPressed: () {
                          takePicture(ImageSource.camera);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.photo_library,
                          color: Constants.colorElement,
                        ),
                        onPressed: () {
                          takePicture(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                  TextField(
                    cursorColor: Constants.colorElement,
                    decoration: InputDecoration(
                        hintText: user.firstName,
                        hintStyle: TextStyle(color: Constants.colorElement),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.colorElement))),
                    onChanged: (data) {
                      setState(() {
                        firstName = data;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: user.lastName,
                        hintStyle: TextStyle(color: Constants.colorElement),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.colorElement))),
                    onChanged: (data) {
                      setState(() {
                        lastName = data;
                      });
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  RaisedButton(
                      onPressed: saveUser,
                      color: Colors.blue,
                      child: Text(
                        "Sauvergader les changements",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  Container(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () {
                      _logOut(context);
                    },
                    child: Text(
                      "Se déconnecter",
                      style: TextStyle(color: Colors.redAccent, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Future<void> _logOut(BuildContext context) async {
    Text title = new Text("Se déconnecter");
    Text subtitle = new Text(("Etes-vous sur?"));
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext build) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? new CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: actionLogout(build),
                )
              : new AlertDialog(
                  title: title,
                  content: subtitle,
                  actions: actionLogout(build),
                );
        });
  }

  List<Widget> actionLogout(BuildContext build) {
    List<Widget> widgets = [];

    widgets.add(FlatButton(
      onPressed: () {
        FireBaseHelper().handleLogout().then((bool) {
          Navigator.of(build).pop();
        });
      },
      child: Text('OUI'),
    ));
    widgets.add(FlatButton(
      onPressed: () => Navigator.of(build).pop(),
      child: Text('NON'),
    ));
    return widgets;
  }

  saveUser() {
    Map map = user.toMap();
    if (firstName != null && firstName.length > 0) {
      map["prenom"] = firstName;
    }
    if (lastName != null && lastName.length > 0) {
      map["nom"] = lastName;
    }
    FireBaseHelper().addUser(user.uid, map);
    getUser();
  }

  Future<void> takePicture(ImageSource imageSource) async {
    File image = await ImagePicker.pickImage(
        source: imageSource, maxWidth: 500, maxHeight: 500);
    // obtenir un url
    FireBaseHelper()
        .savePicture(image, FireBaseHelper().storage_users.child(widget.id))
        .then((data) {
      Map map = user.toMap();
      map["img"] = data;
      FireBaseHelper().addUser(user.uid, map);
      getUser();
    });
  }

  getUser() {
    FireBaseHelper().getUser(widget.id).then((user) {
      setState(() {
        this.user = user;
      });
    });
  }
}
