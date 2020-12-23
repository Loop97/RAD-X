import 'package:flutter/material.dart';

class ReusableIndicator extends StatelessWidget {
  ReusableIndicator(
      {this.color,
      this.height = 50.0,
      this.icon,
      this.iconColor,
      this.iconSize = 20.0,
      @required this.text,
      this.textColor,
      this.textSize = 9.0,
      this.width = 70.0,
      this.upperText});

  final double height;
  final double width;
  final Color color;
  final IconData icon; //required
  final Color iconColor;
  final double iconSize;
  final String text; //required
  final double textSize;
  final Color textColor;
  final String upperText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color ?? Colors.blueGrey[200],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: <Widget>[
          icon != null
              ? Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    upperText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: textColor),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textSize,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
