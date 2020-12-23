import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytask/screens/home.dart';
import 'package:mytask/screens/login_screen.dart';
import 'package:mytask/config/config.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MainApp()));
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final double height = MediaQuery.of(context).size.height;
        return ResponsiveWrapper.builder(child, breakpoints: [
          if (height <= 550)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.76)
          else if (height <= 575)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.79)
          else if (height <= 600)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.82)
          else if (height <= 625)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.85)
          else if (height <= 650)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.88)
          else if (height <= 675)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.91)
          else if (height <= 700)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.94)
          else if (height <= 725)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 0.97)
          else if (height <= 750)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1)
          else if (height <= 775)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.03)
          else if (height <= 800)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.06)
          else if (height <= 825)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.09)
          else if (height <= 850)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.12)
          else if (height <= 875)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.15)
          else if (height <= 900)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.18)
          else if (height <= 925)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.21)
          else if (height <= 950)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.24)
          else if (height <= 975)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.27)
          else if (height <= 1000)
            ResponsiveBreakpoint.resize(360, name: MOBILE, scaleFactor: 1.3)
        ]);
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: secondaryColor,
          brightness: Brightness.light),
          
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          if (user != null && user.isEmailVerified) {
            return HomeScreen(
              email: user.email,
              name: user.displayName,
            );
          } else {
            return LoginScreen();
          }
        }
        return LoginScreen();
      },
    );
  }
}
