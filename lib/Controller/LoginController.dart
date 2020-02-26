import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';

class LoginController extends StatefulWidget {
  LoginControllerState createState() => new LoginControllerState();
}

class LoginControllerState extends State<LoginController> {
  bool _log = true;
  String mail;
  String password;
  String firstName;
  String lastName;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Constants.backgroundColorDark,
      appBar: new AppBar(
        title: Text("Authentification"),
        backgroundColor: Constants.backgroundColorDark,
      ),
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                  elevation: 8.5,
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: cardElements(),
                    ),
                  )),
            ),
            RaisedButton(
              onPressed: _handleLog,
              color: Colors.blue,
              child: Text(
                (_log == true) ? "Connexion" : "Inscription",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleLog() {
    if (mail == null || mail == "") {
      alert("L'adresse mail est vide");
      return;
    }
    if (password == null || password == "") {
      alert("Le mot de passe est vide");
      return;
    }
    if (_log) {
      FireBaseHelper()
          .handleSignIn(mail, password)
          .then((FirebaseUser user) {})
          .catchError((error) {
        alert(error.toString());
      });
    } else {
      if (firstName == null || firstName == "") {
        alert("Le prénom est vide");
        return;
      }
      if (lastName == null || lastName == "") {
        alert("Le nom est vide");
        return;
      }
      FireBaseHelper()
          .handleCreate(mail, password, firstName, lastName)
          .then((FirebaseUser user) {})
          .catchError((error) {
        alert(error.toString());
      });
    }
  }

  Future<void> alert(String error) async {
    Text title = Text("Nous avons une erreur");
    Text subTitle = Text(error);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subTitle,
                  actions: <Widget>[okButton(buildContext)],
                )
              : AlertDialog(
                  title: title,
                  content: subTitle,
                  actions: <Widget>[okButton(buildContext)],
                );
        });
  }

  FlatButton okButton(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("OK"),
    );
  }

  List<Widget> cardElements() {
    List<Widget> widgets = [];

    widgets.add(new TextField(
      decoration: InputDecoration(hintText: "Entrez votre mail"),
      onChanged: (string) {
        setState(() {
          mail = string;
        });
      },
    ));
    widgets.add(new TextField(
      decoration: InputDecoration(hintText: "Entrez votre mot de passe"),
      obscureText: true,
      onChanged: (string) {
        setState(() {
          password = string;
        });
      },
    ));

    if (_log == false) {
      widgets.add(new TextField(
        decoration: InputDecoration(hintText: "Entrez votre prénom"),
        onChanged: (string) {
          setState(() {
            firstName = string;
          });
        },
      ));
      widgets.add(new TextField(
        decoration: InputDecoration(hintText: "Entrez votre nom"),
        onChanged: (string) {
          setState(() {
            lastName = string;
          });
        },
      ));
    }

    widgets.add(new FlatButton(
        onPressed: () {
          setState(() {
            _log = !_log;
          });
        },
        child: new Text((_log == true) ? "Créer un compte" : "Se connecter")));
    return widgets;
  }
}
