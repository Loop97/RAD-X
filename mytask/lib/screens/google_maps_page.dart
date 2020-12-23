import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytask/abstract_widget_view.dart';
import 'package:mytask/models/slider_model.dart';
import 'package:mytask/widgets/colorful_slider_widget.dart';
import 'package:mytask/widgets/map_pin_pill_widget.dart';
import 'package:provider/provider.dart';
import 'package:mytask/models/pin_information.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageController createState() => _GoogleMapsPageController();
}

class _GoogleMapsPageController extends State<GoogleMapsPage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Firestore _db = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  LatLng _lastMapPosition;
  double _cameraZoom = 16;
  MapType _currentMapType = MapType.normal;
  Position _currentPosition;
  double _lat;
  double _lng;
  bool isLoading = true;
  Set<Circle> _circle = Set();
  Color circleColor;
  Map dataMap = Map();
  IconData visibilityIcon = Icons.visibility;
  bool _myLocationEnabled = true;
  double circleRadius = 10.0;
  int pickedColorIndex = 4;
  bool isCameraZoomMoved = false;
  int count = 0;
  double pinPillPosition = -200;

  PinInformation currentlySelectedPin =
      PinInformation(labelColor: Color(0xFF09CAF9));

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    if (_cameraZoom != position.zoom) {
      _cameraZoom = position.zoom;
      isCameraZoomMoved = true;
    }

    if (_cameraZoom >= 10 && _cameraZoom < 11)
      updateCircleRadius(200.0);
    else if (_cameraZoom >= 11 && _cameraZoom < 12)
      updateCircleRadius(150.0);
    else if (_cameraZoom >= 12 && _cameraZoom < 13)
      updateCircleRadius(100.0);
    else if (_cameraZoom >= 13 && _cameraZoom < 14)
      updateCircleRadius(60.0);
    else if (_cameraZoom >= 14 && _cameraZoom < 15)
      updateCircleRadius(30.0);
    else if (_cameraZoom >= 15 && _cameraZoom < 16)
      updateCircleRadius(15.0);
    else if (_cameraZoom >= 16 && _cameraZoom <= 18) updateCircleRadius(10.0);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(
            desiredAccuracy: Platform.isIOS
                ? LocationAccuracy.medium
                : LocationAccuracy.high)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _lat = _currentPosition.latitude;
          _lng = _currentPosition.longitude;
          _center = LatLng(_lat, _lng);
          _lastMapPosition = _center;
        });
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  void addCircle(id, placeinfo, cpm, usph, lat, lng, time, color, location,
      weather, level) {
    _circle.add(Circle(
      circleId: CircleId('$id'),
      center: LatLng(lat, lng),
      fillColor: color,
      strokeColor: color,
      strokeWidth: 1,
      radius: circleRadius,
      consumeTapEvents: true,
      onTap: () {
        setState(() {
          currentlySelectedPin = PinInformation(
            date: time.toDate().toString() ?? "N/A",
            locationName: placeinfo ?? "N/A",
            cpmValue: cpm.toStringAsFixed(0) ?? "N/A",
            usphValue: usph.toStringAsFixed(3) ?? "N/A",
            labelColor: color ?? Color(0xFF09CAF9),
            location: location.toString() ?? 'N/A',
            weather: weather.toString() ?? 'N/A',
            level: level.toString() ?? 'N/A',
          );
          pinPillPosition = 0;
        });
      },
    ));
  }

  void updateCircleRadius(radius) {
    setState(() {
      circleRadius = radius;
    });
  }

  void updateCircle() {
    if (pickedColorIndex == 4)
      _circle = Set.from(_circle
          .map((element) => element.copyWith(
              radiusParam: circleRadius,
              visibleParam: true,
              consumeTapEventsParam: true))
          .toList());
    else if (pickedColorIndex == 3)
      _circle = Set.from(_circle.map((element) {
        if (element.fillColor == Color(0xFF09CAF9))
          return element.copyWith(
              radiusParam: circleRadius,
              visibleParam: true,
              consumeTapEventsParam: true);
        else
          return element.copyWith(
              visibleParam: false, consumeTapEventsParam: false);
      }));
    else if (pickedColorIndex == 2)
      _circle = Set.from(_circle.map((element) {
        if (element.fillColor == Color(0xFF4CAF50))
          return element.copyWith(
              radiusParam: circleRadius,
              visibleParam: true,
              consumeTapEventsParam: true);
        else
          return element.copyWith(
              visibleParam: false, consumeTapEventsParam: false);
      }));
    else if (pickedColorIndex == 1)
      _circle = Set.from(_circle.map((element) {
        if (element.fillColor == Color(0xFFFDD835))
          return element.copyWith(
              radiusParam: circleRadius,
              visibleParam: true,
              consumeTapEventsParam: true);
        else
          return element.copyWith(
              visibleParam: false, consumeTapEventsParam: false);
      }));
    else if (pickedColorIndex == 0)
      _circle = Set.from(_circle.map((element) {
        if (element.fillColor == Color(0xFFFF9800))
          return element.copyWith(
              radiusParam: circleRadius,
              visibleParam: true,
              consumeTapEventsParam: true);
        else
          return element.copyWith(
              visibleParam: false, consumeTapEventsParam: false);
      }));
  }

  void _handleBackButton() {
    Navigator.pop(context);
  }

  Future<void> _getDatabaseRawData() async {
    await _db
        .collection('Data')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              _db
                  .collection('Data')
                  .document(element.documentID)
                  .collection('Recorded Data').orderBy("time", descending: true).limit(150)
                  //.where("time", isGreaterThanOrEqualTo: new DateTime.now().subtract(Duration(days: 1,hours:12)))
                  .getDocuments()
                  .then((value) => value.documents.forEach((element) {
                        var placeinfo = element.data['placeinfo'];
                        var cpm = element.data['cpm'];
                        var usph = element.data['usph'];
                        var lat = element.data['coordinate'][0];
                        var lng = element.data['coordinate'][1];
                        var time = element.data['time'];
                        var location = element.data['location'];
                        var weather = element.data['weather'];
                        var level = element.data['level'];
                        if (usph <= 0.1) {
                          circleColor = Color(0xFF09CAF9);
                        } else if (usph <= 0.4) {
                          circleColor = Color(0xFF4CAF50);
                        } else if (usph <= 2.28) {
                          circleColor = Color(0xFFFDD835);
                        } else {
                          circleColor = Color(0xFFFF9800);
                        }
                        addCircle(count, placeinfo, cpm, usph, lat, lng, time,
                            circleColor, location, weather, level);
                        count++;
                      }));
            }));
  }

  void _handleMyLocationVisibility() {
    setState(() {
      visibilityIcon = (visibilityIcon == Icons.visibility)
          ? Icons.visibility_off
          : Icons.visibility;
      _myLocationEnabled = !_myLocationEnabled;
    });
  }

  void _hidePinPillLocation() {
    setState(() {
      pinPillPosition = -200;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getDatabaseRawData();
  }

  @override
  Widget build(BuildContext context) => _GoogleMapsPageView(this);
}

class _GoogleMapsPageView
    extends WidgetView<GoogleMapsPage, _GoogleMapsPageController> {
  _GoogleMapsPageView(_GoogleMapsPageController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: state.isLoading
            ? null
            : IconButton(
                onPressed: () => state._handleBackButton(),
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              ),
        title: Text('Google Maps'),
        centerTitle: true,
      ),
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Consumer<SliderModel>(builder: (context, value, child) {
                  if (state.isCameraZoomMoved ||
                      state.pickedColorIndex != value.pickedColor) {
                    state.pickedColorIndex = value.pickedColor;
                    state.updateCircle();
                  }
                  return GoogleMap(
                    // zoomControlsEnabled: false,
                    compassEnabled: true,
                    onTap: (LatLng location) => state._hidePinPillLocation(),
                    minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                    myLocationEnabled: state._myLocationEnabled,
                    onMapCreated: state._onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: state._center,
                      zoom: 16.0,
                    ),
                    mapType: state._currentMapType,
                    onCameraMove: (position) async {
                      state._onCameraMove(position);
                      state._hidePinPillLocation();
                    },
                    circles: state._circle,
                  );
                }),
                MapPinPillWidget(
                  pinPillPosition: state.pinPillPosition,
                  currentlySelectedPin: state.currentlySelectedPin,
                  hidePinPillLocation: () => state._hidePinPillLocation(),
                ),
                Positioned(
                  top: 60.0,
                  right: 12.0,
                  child: Container(
                    width: 39.0,
                    height: 39.0,
                    color: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      onPressed: () => state._handleMyLocationVisibility(),
                      icon: Icon(state.visibilityIcon),
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 140.0,
                    right: 8.0,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: ColorfulSliderWidget(
                        width: 200.0,
                      ),
                    )),
              ],
            ),
    );
  }
}
