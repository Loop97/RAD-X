import 'dart:async';
import 'dart:convert' show utf8;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytask/components/reusable_indicator.dart';
import 'package:mytask/models/focused_menu_modal.dart';
import 'package:mytask/models/graph_model.dart';
import 'package:mytask/utilities/focused_menu_holder.dart';
import 'package:mytask/widgets/switchable_graph_widget.dart';
import 'package:provider/provider.dart';
import '../components/reusable_card.dart';
import '../utilities/constants.dart';
import 'package:mytask/abstract_widget_view.dart';
import 'package:mytask/components/reusable_button.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class DataDisplayPage extends StatefulWidget {
  const DataDisplayPage({
    this.loggedInUserEmail,
    this.device,
  });
  final BluetoothDevice device;
  final String loggedInUserEmail;
  @override
  _DataDisplayPageController createState() => _DataDisplayPageController();
}

class _DataDisplayPageController extends State<DataDisplayPage> {
  final TextEditingController _lvlController = TextEditingController();
  //Firebase Attribute
  Firestore _db = Firestore.instance;
  //BLE Data Attribute
  Stream<List<int>> stream;
  Color colour = Color(0xFF09CAF9);
  double cpminute = 0;
  double cpm = 0;
  double microSievertPerMin = 0;
  double microSievert = 0;
  double microSievertPerSecond = 0;
  double cps = 0;
  String battery = '';
  bool isReady = false;
  int counter = 0;
  bool exit = false;
  //Bluetooth Connection Attribute
  FlutterBlue flutterBlue = FlutterBlue.instance;
  IconData iconBlue = Icons.bluetooth_disabled;
  String statusBlue = 'Disconnected';
  Color colorBlue = Colors.grey[50];
  //Data Connection Attribute
  IconData iconWiFi = Icons.signal_wifi_off;
  String statusWiFi = 'Disconnected';
  Color colorWiFi = Colors.grey[50];
  bool hasWIFI = false;
  //Recording Attribute
  IconData iconRecord = Icons.sentiment_dissatisfied;
  String statusRecord = 'Record';
  Color colorRecord = Colors.grey[50];
  bool isRecord = false;
  bool isToggle = false;
  String email;
  int id = 1;
  String iD = "0000001";
  int i = 1;
  //Location_Competition Attributes
  int locationId = 0;
  IconData iconLocation = Icons.sentiment_dissatisfied;
  String statusLocation = 'NA';
  Color colorLocation = Colors.grey[50];

  //Weather Attributes
  int weatherId = 0;
  IconData iconWeather = Icons.sentiment_dissatisfied;
  String statusWeather = 'NA';
  Color colorWeather = Colors.grey[50];

  //Location Attribute
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  double lat;
  double lng;
  FirebaseUser loginUser;
  String _currentAddress;
  //Battery Indicator Attribute
  int batterylvl = 0;
  IconData iconBattery = Icons.battery_unknown;
  Color colorBattery = Colors.grey[50];

  String level = "0";

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      counter += 1;
      _accumulateData();
      updateData();
      if (exit) {
        timer.cancel();
        exit = false;
      }
    });
  }

  void updateData() {
    if (counter >= 60) {
      _updateGraphData(context);
      // _getBatteryState();
      cpminute = cpm;
      microSievertPerMin = microSievert;
      cpm = 0;
      microSievert = 0;
      isToggle = true;
      counter = 0;
      _refreshCardColor();
    } else {
      if (isToggle) isToggle = false;
      _updateGraphDataSec(context);
    }
  }

  void timeOut() {
    Timer(const Duration(seconds: 8), () {
      if (!isReady) {
        disconnectFromDevice();
        _pop();
      }
    });
  }

  void connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }
    timeOut();
    try {
      await widget.device.connect();
    } catch (e) {
      disconnectFromDevice();
    }
    discoverService();
  }

  void disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }
    widget.device.disconnect();
  }

  void discoverService() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == serviceUUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == characteristicUUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            setState(() {
              isReady = true;
            });
            startTimer();
          }
        });
      }
    });

    if (!isReady) {
      _pop();
    }
  }

  void _pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  ////////////++++ Toggling Record State +++++////////////
  void _getCurrentRecordState() {
    if (isRecord && hasWIFI) {
      iconRecord = Icons.sentiment_satisfied;
      colorRecord = Colors.redAccent;
      statusRecord = 'Recording';
      if (isToggle) {
        isToggle = false;
        
        level = _lvlController.text;
        _getCurrentLocation();
        _createField();
        if (cpminute !=0){
        i += 1;
        id += 1;
        iD = id.toString().padLeft(7, '0');
        _createRecord();
      }
      }
    } else {
      statusRecord = 'Record';
      colorRecord = Colors.grey[50];
      iconRecord = Icons.sentiment_dissatisfied;
    }
  }

  /////+++++++++++ Gets WiFi status of user deivce and sets states +++++++++/////
  Future<void> _getDataConnectionState() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      statusWiFi = 'Connected';
      colorWiFi = Colors.greenAccent;
      iconWiFi = Icons.wifi_tethering;
      hasWIFI = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      statusWiFi = 'Connected';
      colorWiFi = Colors.greenAccent;
      iconWiFi = Icons.signal_wifi_4_bar;
      hasWIFI = true;
    } else {
      statusWiFi = 'Disconnected';
      colorWiFi = Colors.grey[50];
      iconWiFi = Icons.signal_wifi_off;
      hasWIFI = false;
    }
  }

  Future<void> _getBluetoothConnectionState() async {
    if (await FlutterBlue.instance.isOn) {
      iconBlue = Icons.bluetooth_connected;
      statusBlue = "Connected";
      colorBlue = Colors.blueAccent;
    } else {
      iconBlue = Icons.bluetooth_disabled;
      colorBlue = Colors.grey[50];
      statusBlue = "Disconnected";
    }
  }

  /////////////+++++++ Getting User Location ++++++++///////////////
  Future<void> _getCurrentLocation() async {
    if (_currentPosition == null) {
      await geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          lat = _currentPosition.latitude;
          lng = _currentPosition.longitude;
        });
        _getAddressFromLatLng();
      }).catchError((e) {
        print(e);
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(lat, lng);

      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.name}, ${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }

  ////////////++++ Retreiving User Name +++++////////////
  void _getUserName() {
    FirebaseAuth.instance.currentUser().then((user) => loginUser = user);
  }

////////////++++ Retrieve Latest Data Entry from Firestore +++++////////////
  Future<void> _getDatabaseRawData() async {
    await _db
        .collection('Data')
        .document(widget.loggedInUserEmail)
        .collection('Recorded Data')
        .orderBy("time", descending: true)
        .limit(1)
        .getDocuments()
        .then((value) {
      bool docExist = value.documents.isNotEmpty;
      if (docExist) {
        id = int.parse(value.documents.last.documentID);
      } else {
        id = 0;
      }
    });
  }

  ////////////++++ Sending DATA to Firestore +++++////////////
  void _createRecord() async {
    await _db
        .collection("Data")
        .document(widget.loggedInUserEmail)
        .collection("Recorded Data")
        .document(iD)
        .setData({
      'id': id,
      'user': widget.loggedInUserEmail,
      'cpm': cpminute,
      'usph': microSievertPerMin,
      'coordinate': [lat, lng],
      'placeinfo': _currentAddress,
      "time": DateTime.now(),
      "location": statusLocation,
      "weather": statusWeather,
      "level": level,
    });
  }

  void _createField() async {
    var userRef = _db.collection("Data").document(widget.loggedInUserEmail);
    userRef.get().then((value) {
      try {
        if (!value.exists)
          userRef.setData({
            'user': widget.loggedInUserEmail,
          });
      } catch (err) {
        userRef.setData({
          'user': widget.loggedInUserEmail,
        });
      }
    });
  }

  void _handleBackButton() {
    setState(() {
      exit = true;
    });
    disconnectFromDevice();
    Future.delayed(Duration(milliseconds: 700))
        .then((value) => Navigator.pop(context));
  }

  void _handleRecordButton() {
    if (isRecord) {
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        setState(() {
          isRecord = false;
          id = id;
          if (cpm != 0){
             _getCurrentRecordState();
          }
         
        });
      });
    } else {
      setState(() {
        isRecord = true;
        id = id;
        _getCurrentRecordState();
      });
    }
  }

  Future<void> _getBatteryState() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    if (batterylvl >= 75) {
      setState(() {
        iconBattery = LineAwesomeIcons.battery_full;
        colorBattery = Colors.greenAccent;
      });
    } else if (batterylvl >= 55 && batterylvl < 75) {
      setState(() {
        iconBattery = LineAwesomeIcons.battery_three_quarters;
        colorBattery = Colors.greenAccent;
      });
    } else if (batterylvl >= 35 && batterylvl < 55) {
      setState(() {
        iconBattery = LineAwesomeIcons.battery_half;
        colorBattery = Colors.greenAccent;
      });
    } else if (batterylvl >= 20 && batterylvl < 35) {
      setState(() {
        iconBattery = LineAwesomeIcons.battery_quarter;
        colorBattery = Colors.yellowAccent;
      });
    } else if (batterylvl >= 10 && batterylvl < 20) {
      setState(() {
        iconBattery = LineAwesomeIcons.battery_empty;
        colorBattery = Colors.redAccent;
      });
    } else if (batterylvl < 10) {
      setState(() {
        iconBattery = Icons.battery_alert;
        colorBattery = Colors.redAccent;
      });
    } else {
      setState(() {
        iconBattery = Icons.battery_unknown;
        colorBattery = Colors.white;
      });
    }
  }

  void _handleLocationState() {
    switch (locationId) {
      case 0:
        {
          setState(() {
            iconLocation = Icons.sentiment_dissatisfied;
            statusLocation = 'NA';
            colorLocation = Colors.black;
          });
        }
        break;
      case 1:
        {
          setState(() {
            iconLocation = Icons.whatshot;
            statusLocation = 'Room, completely enclosed without aircon';
            colorLocation = Colors.black;
          });
        }
        break;
      case 2:
        {
          setState(() {
            iconLocation = Icons.ac_unit;
            statusLocation = 'Room, completely enclosed with aircon';
            colorLocation = Colors.black;
          });
        }
        break;
      case 3:
        {
          setState(() {
            iconLocation = Icons.lock_open;
            statusLocation = 'Room, windows open';
            colorLocation = Colors.black;
          });
        }
        break;
      case 4:
        {
          setState(() {
            iconLocation = LineAwesomeIcons.home;
            statusLocation = 'Outdoors, under shelter';
            colorLocation = Colors.black;
          });
        }
        break;
      case 5:
        {
          setState(() {
            iconLocation = LineAwesomeIcons.sun_o;
            statusLocation = 'Outdoors, not under shelter';
            colorLocation = Colors.black;
          });
        }
        break;
    }
  }

  void _handleWeatherState() {
    switch (weatherId) {
      case 0:
        {
          setState(() {
            iconWeather = Icons.sentiment_dissatisfied;
            statusWeather = 'NA';
            colorWeather = Colors.black;
          });
        }
        break;
      case 1:
        {
          setState(() {
            iconWeather = Icons.wb_sunny;
            statusWeather = 'Sunny';
            colorWeather = Colors.black;
          });
        }
        break;
      case 2:
        {
          setState(() {
            iconWeather = Icons.wb_cloudy;
            statusWeather = 'Cloudy';
            colorWeather = Colors.black;
          });
        }
        break;
      case 3:
        {
          setState(() {
            iconWeather = LineAwesomeIcons.tint;
            statusWeather = 'Raining';
            colorWeather = Colors.black;
          });
        }
        break;
    }
  }

  void _accumulateData() {
    cpm = cpm + cps;
    microSievertPerSecond = cps * kTubeMultiplier;
    microSievert = microSievert + microSievertPerSecond;
  }

  void _refreshCardColor() {
    if (microSievertPerMin <= 0.1) {
      colour = Color(0xFF09CAF9);
    } else if (microSievertPerMin <= 0.4) {
      colour = Color(0xFF4CAF50);
    } else if (microSievertPerMin <= 2.28) {
      colour = Color(0xFFFDD835);
    } else {
      colour = Color(0xFFFF9800);
    }
  }

  Future<void> _updateGraphDataSec(BuildContext context) async {
    await Future.delayed(
        const Duration(milliseconds: 1), () {}); //do not remove
    Provider.of<GraphModel>(context, listen: false).updateCps(cps);
    Provider.of<GraphModel>(context, listen: false)
        .updateUspm(microSievertPerSecond);
  }

  Future<void> _updateGraphData(BuildContext context) async {
    await Future.delayed(
        const Duration(milliseconds: 1), () {}); //do not remove
    Provider.of<GraphModel>(context, listen: false).updateCpm(cpminute);
    Provider.of<GraphModel>(context, listen: false)
        .updateUsph(microSievertPerMin);
    Provider.of<GraphModel>(context, listen: false).updateCps(cps);
    Provider.of<GraphModel>(context, listen: false)
        .updateUspm(microSievertPerSecond);
  }

  @override
  void initState() {
    connectToDevice();
    super.initState();
    _getUserName();
    _getCurrentLocation();
    _getDatabaseRawData();
    i = 0;
  }

  @override
  void dispose() {
    _lvlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DataDisplayPageView(this);
}

class _DataDisplayPageView
    extends WidgetView<DataDisplayPage, _DataDisplayPageController> {
  _DataDisplayPageView(_DataDisplayPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        state._handleBackButton();
        return true;
      },
      child: Scaffold(
        body: LayoutBuilder(
            builder: (context, constraints) => Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    automaticallyImplyLeading: false,
                    leading: state.isReady
                        ? FlatButton(
                            onPressed: () => state._handleBackButton(),
                            child: Icon(Icons.arrow_back),
                          )
                        : null,
                    title: Text('Data Display'),
                    centerTitle: true,
                  ),
                  body: GestureDetector(
                     onTap: () {
   
    FocusScope.of(context).requestFocus(new FocusNode());
  },
                                      child: Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: !state.isReady
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: state.stream,
                                    builder: (c, snapshot) {
                                      if (snapshot.hasError)
                                        return Text(
                                            'Error: ${snapshot.hasError}');
                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        if (snapshot.data.isNotEmpty) {
                                          var receivedValue =
                                              state._dataParser(snapshot.data);
                                          var cpsValue =
                                              receivedValue.split(",")[0];
                                          var batteryValue =
                                              receivedValue.split(",")[1];
                                          state.cps = double.parse(cpsValue);
                                          state.battery = batteryValue + "%";
                                          state.batterylvl =
                                              int.parse(batteryValue);
                                        } else {
                                          state.cps = 0;
                                          state.battery = "0%";
                                        }
                                        state._getBatteryState();
                                        state._getCurrentRecordState();
                                        state._getDataConnectionState();
                                        state._getBluetoothConnectionState();
                                        ////////////++++ Page UI and Widget Layout +++++////////////
                                        return Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                ReusableIndicator(
                                                  upperText: state.i.toString(),
                                                  text: 'Data Entry',
                                                ),
                                                ReusableIndicator(
                                                    icon: state.iconBlue,
                                                    text: state.statusBlue,
                                                    iconColor: state.colorBlue),
                                                ReusableIndicator(
                                                    icon: state.iconWiFi,
                                                    text: state.statusWiFi,
                                                    iconColor: state.colorWiFi),
                                                ReusableIndicator(
                                                    icon: state.iconBattery,
                                                    text: 'Battery Level',
                                                    iconColor:
                                                        state.colorBattery),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: ReusableCard(
                                                      height: 120.0,
                                                      colour: state.colour,
                                                      cardChild: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          const Text(
                                                            'μSv/hr',
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                          Text(
                                                            state
                                                                .microSievertPerMin
                                                                .toStringAsFixed(
                                                                    2),
                                                            style:
                                                                kNumberTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ReusableCard(
                                                      height: 120.0,
                                                      colour: state.colour,
                                                      cardChild: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          const Text(
                                                            'cpm',
                                                            style:
                                                                kLabelTextStyle,
                                                          ),
                                                          Text(
                                                            '${state.cpminute.toInt()}',
                                                            style:
                                                                kNumberTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: FocusedMenuHolder(
                                                      menuWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      blurSize: 5.0,
                                                      menuItemExtent: 45,
                                                      menuBoxDecoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                      duration: Duration(
                                                          milliseconds: 1),
                                                      animateMenuItems: true,
                                                      blurBackgroundColor:
                                                          Colors.black54,
                                                      bottomOffsetHeight: 100,
                                                      menuItems: <
                                                          FocusedMenuItem>[
                                                        FocusedMenuItem(
                                                            title: Text(
                                                                "Room, completely enclosed without air-con",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              Icons.whatshot,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  1;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                                "Room, completely enclosed with air-con",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              Icons.ac_unit,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  2;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                                "Room, windows open",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              Icons.lock_open,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  3;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                              "Outdoors, under shelter",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailingIcon: Icon(
                                                              LineAwesomeIcons
                                                                  .home,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  4;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                              "Outdoors, not under shelter",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailingIcon: Icon(
                                                              LineAwesomeIcons
                                                                  .sun_o,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  5;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                              "N/A",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .sentiment_dissatisfied,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.locationId =
                                                                  0;
                                                              state
                                                                  ._handleLocationState();
                                                            }),
                                                      ],
                                                      onPressed: () {},
                                                      child: Container(
                                                        width: 100,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          border: Border.all(
                                                            color:
                                                                Colors.grey[50],
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10.0),
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                "Location",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                height: 0.5,
                                                              ),
                                                              Icon(
                                                                state
                                                                    .iconLocation,
                                                                color:
                                                                    Colors.black,
                                                                size: 40,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ////////// Seperated Here //////////
                                                  SizedBox(width: 10),
                                                  ////////// Seperated Here //////////
                                                  Expanded(
                                                    child: FocusedMenuHolder(
                                                      menuWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      blurSize: 5.0,
                                                      menuItemExtent: 45,
                                                      menuBoxDecoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                      duration: Duration(
                                                          milliseconds: 1),
                                                      animateMenuItems: true,
                                                      blurBackgroundColor:
                                                          Colors.black54,
                                                      bottomOffsetHeight: 100,
                                                      menuItems: <
                                                          FocusedMenuItem>[
                                                        FocusedMenuItem(
                                                            title: Text("Sunny",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              Icons.wb_sunny,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.weatherId = 1;
                                                              state
                                                                  ._handleWeatherState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text("Cloudy",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              Icons.wb_cloudy,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.weatherId = 2;
                                                              state
                                                                  ._handleWeatherState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text("Raining",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black)),
                                                            trailingIcon: Icon(
                                                              LineAwesomeIcons
                                                                  .tint,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.weatherId = 3;
                                                              state
                                                                  ._handleWeatherState();
                                                            }),
                                                        FocusedMenuItem(
                                                            title: Text(
                                                              "N/A",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .sentiment_dissatisfied,
                                                              color: Colors.black,
                                                            ),
                                                            onPressed: () {
                                                              state.weatherId = 0;
                                                              state
                                                                  ._handleWeatherState();
                                                            }),
                                                      ],
                                                      onPressed: () {},
                                                      child: Container(
                                                        width: 100,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          border: Border.all(
                                                            color:
                                                                Colors.grey[50],
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10.0),
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                "Weather",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                height: 0.5,
                                                              ),
                                                              Icon(
                                                                state.iconWeather,
                                                                color:
                                                                    Colors.black,
                                                                size: 40,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ////////// Seperated Here //////////
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        border: Border.all(
                                                          color: Colors.grey[50],
                                                          width: 3,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              "Floor Level",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Container(
                                                              height: 38,
                                                              child: TextField(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .phone,
                                                                controller: state
                                                                    ._lvlController,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SwitchableGraphWidget()),
                                          ],
                                        );
                                      } else {
                                        state.cps = 0;
                                        state.battery = "0%";
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                  ReusableButton(
                                    text: state.statusRecord,
                                    textColor: Colors.white,
                                    onPressed: () => state._handleRecordButton(),
                                    icon: state.iconRecord,
                                    iconColor: state.colorRecord,
                                    borderColor: state.colorRecord,
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                )),
      ),
    );
  }
}
