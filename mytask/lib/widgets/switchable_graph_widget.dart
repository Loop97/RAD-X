import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytask/screens/graph_screens/cpm_graph.dart';
import 'package:mytask/screens/graph_screens/cps_graph.dart';
import 'package:mytask/screens/graph_screens/usph_graph.dart';
import 'package:mytask/screens/graph_screens/uspm_graph.dart';
import 'package:mytask/utilities/constants.dart';

class SwitchableGraphWidget extends StatefulWidget {
  @override
  _SwitchableGraphWidgetState createState() => _SwitchableGraphWidgetState();
}

class _SwitchableGraphWidgetState extends State<SwitchableGraphWidget> {
  int chartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.50,
          child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: const Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 28.0, bottom: 8.0, left: 8.0, right: 16.0),
                child: chartCount == 0
                    ? CpsGraph()
                    : chartCount == 1
                        ? CpmGraph()
                        : chartCount == 2
                            ? UspmGraph()
                            : chartCount == 3
                                ? UsphGraph()
                                : LineChart(LineChartData()),
              )),
        ),
        Positioned(
          right: 65.0,
          top: 5.0,
          child: SizedBox(
            width: 40,
            height: 15,
            child: Container(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                kGraphLabelText[chartCount],
                style: TextStyle(
                  fontSize: 12,
                  color: kGraphLabelColor[chartCount],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 30.0,
          top: 5.0,
          child: SizedBox(
            width: 35,
            height: 25,
            child: IconButton(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
              onPressed: () {
                setState(() {
                  if (chartCount > 0) {
                    chartCount -= 1;
                  } else {
                    chartCount = 3;
                  }
                });
              },
              icon: FaIcon(
                FontAwesomeIcons.backward,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 5.0,
          top: 5.0,
          child: SizedBox(
            width: 35,
            height: 25,
            child: IconButton(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
              onPressed: () {
                setState(() {
                  if (chartCount < 3) {
                    chartCount += 1;
                  } else {
                    chartCount = 0;
                  }
                });
              },
              icon: FaIcon(
                FontAwesomeIcons.forward,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
