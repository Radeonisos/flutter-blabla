import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blabla/Controller/LoginController.dart';
import 'package:flutter_blabla/Controller/MainAppController.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: _handleAuth(),
    );
  }

  Widget _handleAuth() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot){
           if (snapshot.hasData){
             return MainAppController();
          } else {
             return LoginController();
           }
        });
  }
}