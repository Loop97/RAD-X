import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DataAnalyticalPage extends StatefulWidget {
  const DataAnalyticalPage({
    this.loggedInUserEmail,
  });
  final String loggedInUserEmail;
  @override
  _DataAnalyticalPageState createState() => _DataAnalyticalPageState();
}

class _DataAnalyticalPageState extends State<DataAnalyticalPage> {
  Firestore _db = Firestore.instance;
  bool isToggle = false;
  bool isTableReady = false;
  double idWidth = 50;
  double cpmWidth = 80;
  double usphWidth = 80;
  double coorWidth = 100;
  double placeWidth = 180;
  double dateWidth = 180;
  double locationWidth = 180;
  double weatherWidth = 100;
  double levelWidth = 100;
  String coor_lat;
  String coor_lng;

  Future<void> _getDatabaseRawData() async {
    await _db
        .collection('Data')
        .document(widget.loggedInUserEmail)
        .collection('Recorded Data')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              var placeinfo = element.data['placeinfo'];
              var cpm = element.data['cpm'];
              var usph = element.data['usph'];
              var lat = element.data['coordinate'][0];
              var lng = element.data['coordinate'][1];
              var date = element.data['time'];
              var id = element.data['id'];
              var location = element.data['location'];
              var weather = element.data['weather'];
              var level = element.data['level'];

             
              
              if (lat == null || lng == null){
                coor_lat = "null";
                coor_lng = "null";
              }else{
                coor_lat = lat.toStringAsFixed(5);
                coor_lng = lng.toStringAsFixed(5);
              }
              user.initData(
                  id.toString(),
                  cpm.toStringAsFixed(0) ?? 'N/A',
                  usph.toStringAsFixed(3) ?? 'N/A',
                  "($coor_lat, $coor_lng)" ??
                      'N/A',
                  placeinfo.toString() ?? 'N/A',
                  date.toDate().toString() ?? 'N/A',
                  location.toString() ?? 'N/A',
                  weather.toString() ?? 'N/A',
                  level.toString() ?? 'N/A',
                  );
            }))
        .whenComplete(() {
      setState(() {
        isTableReady = true;
      });
    });
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: idWidth,
        rightHandSideColumnWidth: idWidth +
            cpmWidth +
            usphWidth +
            coorWidth +
            placeWidth +
            dateWidth +
            locationWidth +
            weatherWidth +
            levelWidth ,
            
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: user.userInfo.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('ID', idWidth),
      _getTitleItemWidget('CPM', cpmWidth),
      _getTitleItemWidget('μS/hr', usphWidth),
      _getTitleItemWidget('Coordinate', coorWidth),
      _getTitleItemWidget('Place', placeWidth),
      _getTitleItemWidget('Date', dateWidth),
      _getTitleItemWidget('Location', locationWidth),
      _getTitleItemWidget('Weather', weatherWidth),
      _getTitleItemWidget('Level', levelWidth),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(user.userInfo[index].id),
      width: idWidth,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(user.userInfo[index].cpm),
          width: cpmWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].usph),
          width: usphWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].coordinate),
          width: coorWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].placeinfo),
          width: placeWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].date),
          width: dateWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].location),
          width: locationWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].weather),
          width: weatherWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(user.userInfo[index].level),
          width: levelWidth,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  @override
  void initState() {
    _getDatabaseRawData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () => isToggle
                ? SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]).whenComplete(
                    () => Navigator.pop(context),
                  )
                : Navigator.pop(context),
          ),
          title: Text('Historical Data'),
          centerTitle: true,
          actions: <Widget>[
            isToggle
                ? IconButton(
                    icon: Icon(Icons.rotate_left),
                    onPressed: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                      isToggle = !isToggle;
                    })
                : IconButton(
                    icon: Icon(Icons.rotate_right),
                    onPressed: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                      isToggle = !isToggle;
                    })
          ],
        ),
        body: isTableReady ? _getBodyWidget() : null);
  }

  @override
  void dispose() {
    user.clearData();
    super.dispose();
  }
}

User user = User();

class User {
  List<UserInfo> _userInfo = List<UserInfo>();

  void initData(
      String id,
      String cpm,
      String usph,
      String coordinate,
      String placeinfo,
      String date,
      String location,
      String weather,
      String level) {
    _userInfo.add(UserInfo(
        id: id,
        cpm: cpm,
        usph: usph,
        coordinate: coordinate,
        placeinfo: placeinfo,
        date: date,
        location: location,
        weather: weather,
         level: level,));
  }

  void clearData() {
    _userInfo.clear();
  }

  List<UserInfo> get userInfo => _userInfo;

  set userInfo(List<UserInfo> value) {
    _userInfo = value;
  }
}

class UserInfo {
  String id;
  String cpm;
  String usph;
  String coordinate;
  String placeinfo;
  String date;
  String location;
  String weather;
  String level;

  UserInfo(
      {this.id,
      this.cpm,
      this.usph,
      this.coordinate,
      this.placeinfo,
      this.date,
      this.level,
      this.location,
      this.weather});
}
