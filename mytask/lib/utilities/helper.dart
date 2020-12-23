String emailValidator(value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

String pwdValidator(value) {
  if (value.length < 6) {
    return 'Password must be longer than 6 characters';
  } else {
    return null;
  }
}

//void createNewUser() {
//  _firestore
//      .collection("users")
//      .document(newUser.uid)
//      .setData({
//        "uid": newUser.uid,
//        "name": _userNameInputController.text,
//        "email": _emailInputController.text,
//      })
//      .then((result) {
//        Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(
//                builder: (context) => HomePage(
//                      title: _userNameInputController.text + "'s Tasks",
//                      uid: newUser.uid,
//                    )),
//            (_) => false);
//      })
//      .catchError((err) => print(err))
//      .catchError((err) => print(err));
//}
