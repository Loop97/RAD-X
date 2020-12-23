import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytask/config/config.dart';
import 'package:mytask/screens/email_pass_signup.dart';
import 'package:mytask/screens/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final TextEditingController _resetController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.clear();
    _emailController.clear();
  }

  ///Reset Password
  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String errorMessage;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;

        _db.collection("Users").document("Last Usage").setData({
          "email": email,
          "lastseen": DateTime.now(),
        });
        if (user.isEmailVerified) {
          setState(() {
            _isLoading = false;
          });
             Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
              email: user.email,
              name: user.displayName,
            )));
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text("Success"),
                  content: Text(
                      "Welcome to Rad - X"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        _emailController.text = "";
                        _passwordController.text = "";
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          setState(() {
            _isLoading = false;
          });
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text("Error"),
                  content: Text(
                      "Please verify email before signing in. Do you need a new verification link?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        _emailController.text = "";
                        _passwordController.text = "";
                        user.sendEmailVerification();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              });
        }
      } catch (error) {
        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
      }
      if (errorMessage != null) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Error"),
                content: Text("$errorMessage"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      _emailController.text = "";
                      _passwordController.text = "";
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text("Please provide email and password..."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 1.25 * MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: 40,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 60,
                      ),
                      child: Image(
                        image: AssetImage("assets/EIC2020_Logo.png"),
                        width: 200,
                        height: 150,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                        top: 2,
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Write Email Here",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                        top: 2,
                      ),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            hintText: "Write Password Here",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: _passwordVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            )),
                        obscureText: !_passwordVisible,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _signIn();
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
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmailPassSignupScreen()));
                      },
                      child: Text("Signup using Email"),
                    ),
                    FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text("Warning"),
                                content: Container(
                                  height: 200,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          "Are you sure you would like to reset your password?"),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: _resetController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Email",
                                          hintText: "Write Email Here",
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.blueGrey,
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          ),
                                          SizedBox(width: 40),
                                          FlatButton(
                                            child: Text("Yes"),
                                            onPressed: () {
                                              String reset =
                                                  _resetController.text;
                                              if (reset.isNotEmpty)
                                                resetPassword(
                                                    _resetController.text);
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      title: Text(
                                                          "Reset Password"),
                                                      content: Text(
                                                          "An email has been sent to your account to reset your password"),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.blueGrey,
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text("Reset Password"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
