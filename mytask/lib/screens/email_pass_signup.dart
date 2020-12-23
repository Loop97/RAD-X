import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:mytask/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailPassSignupScreen extends StatefulWidget {
  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Email Sign Up"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: 1,
                ),
                child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      hintText: "Write Username Here",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: 1,
                ),
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: "Write Email Here",
                    ),
                    keyboardType: TextInputType.emailAddress),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: 1,
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Write Password Here",
                  ),
                  obscureText: true, // hide character
                ),
              ),
              InkWell(
                onTap: () {
                  _signup(_nameController.text, _emailController.text,
                      _passwordController.text);
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Center(
                      child: Text(
                    "Sign Up using Email",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
            ]),
          ),
        ));
  }

  Future<void> _signup(String username, String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
    try{
      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = username;
      await user.updateProfile(updateInfo);

      _db.collection("Users").document(email).setData({
        "name": username,
        "email": email,
        "lastseen": DateTime.now(),
      });

      try {
        bool userVerification = false;
        await user
            .sendEmailVerification()
            .whenComplete(() => userVerification = true);
        !userVerification
            ? CircularProgressIndicator()
            : showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text("Sucess"),
                      content: Text(
                          "Sign Up Complete. Please proceed to verify your account and sign in."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ]);
                });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text("An error occured while trying to send email"),
                  content: Text("${e.message}"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ]);
            });
      }
    }catch (error) {
       showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text("An error occured while trying to send email"),
                  content: Text("${error.message}"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ]);
            });
    }
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Error"),
                content: Text("Please provide email and password"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ]);
          });
    }
  }
}
