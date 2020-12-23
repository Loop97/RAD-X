import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytask/config/config.dart';
import 'package:mytask/screens/bluetooth_screens/find_devices_screen.dart';
import 'package:mytask/screens/home.dart';

class ReusableDrawer extends StatefulWidget {
  @override
  _ReusableDrawerState createState() => _ReusableDrawerState();
}

class _ReusableDrawerState extends State<ReusableDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      child: Drawer(
        elevation: 16.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'SNRSI Rad-X',
                    style: TextStyle(fontSize: 30.0, fontFamily: 'Pacifico'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(FontAwesomeIcons.ruler),
            //   title: Text('Data Analyser'),
            //   onTap: () => Navigator.pushNamed(context, FindDevicesScreen.id),
            // ),
//          ListTile(
//            leading: Icon(Icons.bluetooth_searching),
//            title: Text('Bluetooth Connection'),
//            onTap: () => Navigator.pushNamed(context, '/findDevices'),
//          ),
          ],
        ),
      ),
    );
  }
}
