import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class GraphModel extends ChangeNotifier {
  List<double> xCpsData = [0];
  List<double> yCpsData = [0];
  List<double> xCpmData = [0];
  List<double> yCpmData = [0];
  List<double> xUspmData = [0];
  List<double> yUspmData = [0];
  List<double> xUsphData = [0];
  List<double> yUsphData = [0];

  List<FlSpot> cpsList = [FlSpot(0, 0)];
  double maxYCps = 0;
  double cpsMagic = 0;
  double xFillerCps = 1;

  List<FlSpot> cpmList = [FlSpot(0, 0)];
  double maxYCpm = 0;
  double cpmMagic = 0;
  double xFillerCpm = 1;

  List<FlSpot> usphList = [FlSpot(0, 0)];
  double maxYUsph = 0;
  double usphMagic = 0;
  double xFillerUsph = 1;

  List<FlSpot> uspmList = [FlSpot(0, 0)];
  double maxYUspm = 0;
  double uspmMagic = 0;
  double xFillerUspm = 1;

// CPS part
  get xFirstCps => xCpsData.first;
  get xLastCps => xCpsData.last;
  get cpsDataPoint => cpsList;
  get xCpsLength => xCpsData.length;
  get maxCpsY => maxYCps;
  get intervalCpsY => maxYCps / 10;

  Future<void> updateCps(double data) async {
    if (yCpsData.length >= 17) {
      xCpsData.removeAt(0);
      xCpsData.add(xFillerCps);
      cpsMagic++;
      yCpsData.removeAt(0);
      yCpsData.add(data);
    } else {
      xCpsData.add(xFillerCps);
      yCpsData.add(data);
    }
    maxYCps = yCpsData.reduce(max) * 1.5;
    updateCpsList();
    xFillerCps++;
    resetCps();
    notifyListeners();
  }

  Future<void> updateCpsList() async {
    cpsList = yCpsData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble() + cpsMagic, e.value);
    }).toList();
  }

  Future<void> resetCps() async {
    if (cpsMagic > 463) {
      xCpsData = [0];
      yCpsData = [0];
      cpsList = [FlSpot(0, 0)];
      cpsMagic = 0;
      xFillerCps = 1;
    }
  }
  // CPS part

// CPM part
  get xFirstCpm => xCpmData.first ?? 0;
  get xLastCpm => xCpmData.last ?? 0;
  get cpmDataPoint => cpmList;
  get xCpmLength => xCpmData.length ?? 0;
  get maxCpmY => maxYCpm ?? 0;
  get intervalCpmY => (maxYCpm / 10) ?? 0;
  get cpmDataPointLength => cpmList.length;

  Future<void> updateCpm(double data) async {
    if (yCpmData.length >= 17) {
      xCpmData.removeAt(0);
      xCpmData.add(xFillerCpm);
      cpmMagic++;
      yCpmData.removeAt(0);
      yCpmData.add(data);
    } else {
      xCpmData.add(xFillerCpm);
      yCpmData.add(data);
    }
    maxYCpm = yCpmData.reduce(max) * 1.5;
    updateCpmList();
    xFillerCpm++;
    resetCpm();
    notifyListeners();
  }

  Future<void> updateCpmList() async {
    cpmList = yCpmData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble() + cpmMagic, e.value);
    }).toList();
  }

  Future<void> resetCpm() async {
    if (cpmMagic > 15) {
      xCpmData = [0];
      yCpmData = [0];
      cpmList = [FlSpot(0, 0)];
      cpmMagic = 0;
      xFillerCpm = 1;
    }
  }
  //CPM Part

  // USPM part
  get xFirstUspm => xUspmData.first;
  get xLastUspm => xUspmData.last;
  get uspmDataPoint => uspmList;
  get xUspmLength => xUspmData.length;
  get maxUspmY => maxYUspm;
  get intervalUspmY => maxYUspm / 10;
  get uspmDataPointLength => uspmList.length;

  Future<void> updateUspm(double data) async {
    if (yUspmData.length >= 17) {
      xUspmData.removeAt(0);
      xUspmData.add(xFillerUspm);
      uspmMagic++;
      yUspmData.removeAt(0);
      yUspmData.add(data);
    } else {
      xUspmData.add(xFillerUspm);
      yUspmData.add(data);
    }
    maxYUspm = yUspmData.reduce(max) * 1.5;
    updateUspmList();
    xFillerUspm++;
    resetUspm();
    notifyListeners();
  }

  Future<void> updateUspmList() async {
    uspmList = yUspmData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble() + uspmMagic, e.value);
    }).toList();
  }

  Future<void> resetUspm() async {
    if (uspmMagic > 463) {
      xUspmData = [0];
      yUspmData = [0];
      uspmList = [FlSpot(0, 0)];
      uspmMagic = 0;
      xFillerUspm = 1;
    }
  }
  //USPM Part

  // USPH part
  get xFirstUsph => xUsphData.first ?? 0;
  get xLastUsph => xUsphData.last ?? 0;
  get usphDataPoint => usphList;
  get xUsphLength => xUsphData.length ?? 0;
  get maxUsphY => maxYUsph ?? 0;
  get intervalUsphY => (maxYUsph / 10) ?? 0;
  get usphDataPointLength => usphList.length;

  Future<void> updateUsph(double data) async {
    if (yUsphData.length >= 17) {
      xUsphData.removeAt(0);
      xUsphData.add(xFillerUsph);
      usphMagic++;
      yUsphData.removeAt(0);
      yUsphData.add(data);
    } else {
      xUsphData.add(xFillerUsph);
      yUsphData.add(data);
    }
    maxYUsph = yUsphData.reduce(max) * 1.5;
    updateUsphList();
    xFillerUsph++;
    resetUsph();
    notifyListeners();
  }

  Future<void> updateUsphList() async {
    usphList = yUsphData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble() + usphMagic, e.value);
    }).toList();
  }

  Future<void> resetUsph() async {
    if (usphMagic > 15) {
      xUsphData = [0];
      yUsphData = [0];
      usphList = [FlSpot(0, 0)];
      usphMagic = 0;
      xFillerUsph = 1;
    }
  }
  //USPH Part
}
