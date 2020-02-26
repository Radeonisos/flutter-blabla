import 'package:firebase_database/firebase_database.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String imgUrl;
  String initial;

  User(DataSnapshot snapshot) {
    Map map = snapshot.value;
    uid = map["uid"];
    firstName = map["prenom"];
    lastName = map["nom"];
    imgUrl = map["img"];
    if (firstName != null && firstName.length > 0) {
      initial = firstName[0].toUpperCase();
    }
    if (lastName != null && lastName.length > 0) {
      if (initial != null) {
        initial += lastName[0].toUpperCase();
      } else {
        initial = lastName[0].toUpperCase();
      }
    }
  }

  toMap() {
    return {"prenom": firstName, "nom": lastName, "img": imgUrl, "uid": uid};
  }
}
