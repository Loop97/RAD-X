import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:mytask/config/config.dart';
import 'package:mytask/models/graph_model.dart';
import 'package:mytask/models/slider_model.dart';
import 'package:mytask/screens/bluetooth_screens/find_devices_screen.dart';
import 'package:mytask/screens/data_display_page.dart';
import 'package:mytask/screens/general_education_page.dart';
import 'package:mytask/screens/google_maps_page.dart';
import 'package:provider/provider.dart';
import 'package:mytask/screens/data_analytical_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.email, this.name});
  final String email;
  final String name;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BluetoothDevice device;
  int _current = 0;

  static final List<String> imgList = [
    'http://snrsi.nus.edu.sg/images/outreach/announcement_1-1.png',
    'http://snrsi.nus.edu.sg/images/outreach/announcement_1-2.png'
  ];

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        fit: BoxFit.contain,
                        width: 1000.0,
                        height: 1000.0,
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
  FirebaseUser user;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Card(
            color: thirdColor,
            elevation: 5.0,
            child: Column(children: [
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    height: 220.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 8),
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
          SizedBox(
            height: 10.0,
            width: MediaQuery.of(context).size.width,
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: RoundedRectangleImageInkWell(
                  onPressed: () {
                    if (device != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => GraphModel(),
                              child: DataDisplayPage(
                                device: device,
                                loggedInUserEmail: widget.email,
                              ),
                            ),
                          ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text("Bluetooth device not found."),
                              content:
                                  Text("Please connect to a device first!"),
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
                                    Navigator.of(ctx).pop();
                                    findDevice();
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: const Radius.circular(20)),
                  image: AssetImage("assets/data_button.png"),
                ),
              ),
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: RoundedRectangleImageInkWell(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => SliderModel(),
                            child: GoogleMapsPage(),
                          ),
                        ));
                  },
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: const Radius.circular(20)),
                  image: AssetImage("assets/map_button.png"),
                ),
              ),
            ],
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: RoundedRectangleImageInkWell(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeneralEducationPage(),
                        ));
                  },
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: const Radius.circular(20)),
                  image: AssetImage("assets/education_button.png"),
                ),
              ),
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: RoundedRectangleImageInkWell(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataAnalyticalPage(
                              loggedInUserEmail: widget.email,
                            ),
                          ));
                    },
                    width: 120,
                    height: 120,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: const Radius.circular(20)),
                    image: AssetImage("assets/data_Analytics.png")),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin: EdgeInsets.all(0),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonHeight: 40.0,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 100.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    color: thirdColor,
                  ),
                ),
                Container(
                  width: 100.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      findDevice();
                    },
                    child: Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                    ),
                    color: thirdColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text("Logged in as: ${widget.name}"),
          )
        ]),
      ),
    );
  }

  Widget textSection = Container(
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    child: Text(
        "So to ellaborate today's Challenge. The homescreen will consist of an annoucement page with a message saying 'Hi' to the user. At the bottom will be Three buttons to direct to the other pages.",
        style: TextStyle(fontWeight: FontWeight.w800)),
  );

  void findDevice() async {
    device = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FindDevicesScreen(
            device: device,
          ),
        ));
  }
}
