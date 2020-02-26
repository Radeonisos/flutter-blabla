import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';
import 'package:flutter_blabla/Model/FirebaseHelper.dart';
import 'package:flutter_blabla/Model/Menu.dart';

import 'ContactsController.dart';
import 'MessagesController.dart';
import 'ProfilController.dart';

class MainAppController extends StatefulWidget {
  MainAppControllerState createState() => new MainAppControllerState();
}

class MainAppControllerState extends State<MainAppController> {
  String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireBaseHelper().myId().then((uid) {
      setState(() {
        id = uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Text title = Text("Flutter BlaBla");
    return new FutureBuilder(
      future: FireBaseHelper().auth.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (Theme.of(context).platform == TargetPlatform.android) {
            return DefaultTabController(
              length: 3,
              child: new Scaffold(
                backgroundColor: Constants.backgroundColorDark,
                appBar: AppBar(
                  backgroundColor: Constants.backgroundColorDark,
                  title: title,
                  centerTitle: true,
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Menu.choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    )
                  ],
                  bottom: TabBar(
                    indicatorColor: Constants.colorElement,
                    tabs: [
                      new Tab(
                        icon: Icon(Icons.message),
                      ),
                      new Tab(
                        icon: Icon(Icons.supervisor_account),
                      ),
                      new Tab(
                        icon: Icon(Icons.account_circle),
                      )
                    ],
                  ),
                ),
                body: new TabBarView(children: controllers()),
              ),
            );
          } else {
            return new CupertinoTabScaffold(
                tabBar: new CupertinoTabBar(
                    backgroundColor: Colors.blue,
                    activeColor: Colors.black,
                    inactiveColor: Colors.white,
                    items: [
                      new BottomNavigationBarItem(
                        icon: new Icon(Icons.message),
                      ),
                      new BottomNavigationBarItem(
                        icon: new Icon(Icons.supervisor_account),
                      ),
                      new BottomNavigationBarItem(
                        icon: new Icon(Icons.account_circle),
                      ),
                    ]),
                tabBuilder: (BuildContext context, int index) {
                  Widget controllerSelected = controllers()[index];
                  return new Scaffold(
                    appBar: new AppBar(
                      title: title,
                    ),
                    body: controllerSelected,
                  );
                });
          }
        } else {
          // loader
          return new Scaffold(
            backgroundColor: Constants.backgroundColorDark,
            appBar: new AppBar(
              title: title,
              backgroundColor: Constants.backgroundColorDark,
            ),
            body: new Center(
              child: Text(
                "Chargement",
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    color: Constants.colorElement),
              ),
            ),
          );
        }
      },
    );
  }

  List<Widget> controllers() {
    return [
      new MessagesController(id),
      new ContactsController(id),
      new ProfilController(id)
    ];
  }

  void choiceAction(String choice) {
    if (choice == Menu.ColorTheme) {
      print('Settings');
    } else if (choice == Menu.SignOut) {
      print('SignOut');
    }
  }
}
