import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mytask/models/pin_information.dart';

class MapPinPillWidget extends StatefulWidget {
  final double pinPillPosition;
  final PinInformation currentlySelectedPin;
  final Function hidePinPillLocation;

  MapPinPillWidget(
      {this.pinPillPosition,
      this.currentlySelectedPin,
      this.hidePinPillLocation});

  @override
  _MapPinPillWidgetwidget createState() => _MapPinPillWidgetwidget();
}

class _MapPinPillWidgetwidget extends State<MapPinPillWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        bottom: widget.pinPillPosition,
        right: 0,
        left: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTapDown: (details) => widget.hidePinPillLocation(),
            child: Container(
              margin: EdgeInsets.all(20),
              width: 300.0,
              height: 110.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 50,
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: widget.currentlySelectedPin.labelColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10.0, right: 7.0, top: 5.0, bottom: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AutoSizeText(
                            widget.currentlySelectedPin.locationName,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 11.0),
                            maxLines: 1,
                            minFontSize: 6.0,
                          ),
                          Divider(
                            height: 4.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 50.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      AutoSizeText(
                                        'Cpm',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                      AutoSizeText(
                                        'μS/hr',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                      AutoSizeText(
                                        'Time',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                      AutoSizeText(
                                        'Location',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                      AutoSizeText(
                                        'Weather',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                      AutoSizeText(
                                        'Level',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.cpmValue}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.usphValue}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.date}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.location}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.weather}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                    Container(
                                      height: 13.0,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        ': ${widget.currentlySelectedPin.level}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11.0),
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        duration: Duration(milliseconds: 200));
  }
}
