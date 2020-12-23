import 'package:flutter/material.dart';
import 'package:mytask/models/slider_model.dart';
import 'package:provider/provider.dart';

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(position, size.height / 2), 12,
        Paint()..color = Colors.blue[200].withOpacity(0.9));
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}

class ColorfulSliderWidget extends StatefulWidget {
  final double width;
  ColorfulSliderWidget({this.width});
  @override
  _ColorfulSliderWidgetState createState() => _ColorfulSliderWidgetState();
}

class _ColorfulSliderWidgetState extends State<ColorfulSliderWidget> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 140, 0),
    Color.fromARGB(255, 255, 215, 0),
    Color.fromARGB(255, 0, 180, 50),
    Color.fromARGB(255, 0, 185, 255),
    Color.fromARGB(255, 255, 255, 255),
  ];
  double _colorSliderPosition;
  Color _currentColor;
  @override
  initState() {
    super.initState();
    _colorSliderPosition = widget.width;
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
  }

  void _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    // print("New pos: $position");
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(_colorSliderPosition);
    });
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray =
        (position / widget.width * (_colors.length - 1));
    // print(positionInColorArray);
    int index = positionInColorArray.truncate();
    Provider.of<SliderModel>(context, listen: false).updateColor(index);
    // print(index);
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              // print("_-------------------------STARTED DRAG");
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            //This outside padding makes it much easier to grab the   slider because the gesture detector has
            // the extra padding to recognize gestures inside of
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white30),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: _colors),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_colorSliderPosition),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
