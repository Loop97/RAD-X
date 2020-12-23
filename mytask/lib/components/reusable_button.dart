import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton(
      {this.color,
      this.height = 60.0,
      this.icon,
      this.iconColor,
      this.iconSize = 22.0,
      @required this.text,
      this.textColor,
      this.textSize = 16.0,
      this.width = 180.0,
      this.onPressed,
      this.borderColor});

  final double height;
  final double width;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String text;
  final double textSize;
  final Color textColor;
  final VoidCallback onPressed;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5.0),
      child: RaisedButton(
        onPressed: onPressed,
        color: color ?? Colors.blueGrey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(width: 5.0),
            Text(text, style: TextStyle(color: textColor, fontSize: textSize)),
          ],
        ),
      ),
    );
  }
}
