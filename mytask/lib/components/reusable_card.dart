import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {this.colour,
      this.cardChild,
      this.onPress,
      this.margin,
      this.padding,
      this.width,
      this.height});

  final Color colour;
  final Widget cardChild;
  final Function onPress;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
            height: height,
            width: width,
            child: cardChild,
            padding: padding ?? EdgeInsets.all(5.0),
            margin: margin ?? EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(10.0),
            )),
      ),
    );
  }
}
