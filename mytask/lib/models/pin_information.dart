import 'package:flutter/material.dart';

class PinInformation {
  final String date;
  final String locationName;
  final Color labelColor;
  final String cpmValue;
  final String usphValue;
  final String location;
  final String weather;
  final String level;

  PinInformation({
    this.date = "",
    this.locationName = "",
    this.labelColor = const Color(0xFF09CAF9),
    this.cpmValue = "",
    this.usphValue = "",
    this.level = '',
    this.location = '',
    this.weather = '',
  });
}
