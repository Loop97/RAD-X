import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'bluetooth_widgets/bluetooth_widgets.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({this.device});
  final BluetoothDevice device;
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  BluetoothDevice linkedDevice;
  bool isLinked = false;

  @override
  void initState() {
    setState(() {
      linkedDevice = widget.device;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, linkedDevice);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, linkedDevice),
              icon: Icon(Icons.arrow_back)),
          title: Text(' Devices'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                isLinked
                    ? linkedDevice == null
                        ? Container()
                        : ListTile(
                            leading: SizedBox(),
                            title: Text(linkedDevice.name),
                            subtitle: Text(linkedDevice.id.toString()),
                            trailing: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    isLinked = false;
                                    linkedDevice = null;
                                  });
                                },
                                child: Text(
                                  'Unlink',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                )))
                    : linkedDevice == null
                        ? Container()
                        : ListTile(
                            leading: SizedBox(),
                            title: Text(linkedDevice.name),
                            subtitle: Text(linkedDevice.id.toString()),
                            trailing: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    isLinked = false;
                                    linkedDevice = null;
                                  });
                                },
                                child: Text(
                                  'Unlink',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ))),
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data
                        .map(
                          (r) => ScanResultTile(
                              result: r,
                              onTap: () {
                                setState(() {
                                  linkedDevice = r.device;
                                  isLinked = true;
                                });
                                // Navigator.pop(context, linkedDevice);
                              }),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}
