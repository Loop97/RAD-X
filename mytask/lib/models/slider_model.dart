import 'package:flutter/cupertino.dart';

class SliderModel extends ChangeNotifier {
  int _colorIndex = 4;

  get pickedColor => _colorIndex;

  Future<void> updateColor(int colorIndex) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    _colorIndex = colorIndex;
    notifyListeners();
  }
}
