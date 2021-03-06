import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier{
  int _currentIndexPage=0;
  int get currentIndexPage=>_currentIndexPage;
  void changePage(int index)
  {
    _currentIndexPage=index;
    notifyListeners();
  }

  double _translationY=0.0;
  double get translationY=>_translationY;
  void animationTranslationY(double translationY)
  {
    _translationY=translationY;
    notifyListeners();
  }
}