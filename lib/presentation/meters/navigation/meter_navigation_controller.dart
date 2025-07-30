import 'package:flutter/material.dart';
import '../../../data/models/meter_model.dart';

class MeterNavigationController extends ChangeNotifier {
  int _selectedTabIndex = 0;
  int _selectedLiveSubTabIndex = 0;
  final MeterModel meter;

  MeterNavigationController({required this.meter});

  int get selectedTabIndex => _selectedTabIndex;
  int get selectedLiveSubTabIndex => _selectedLiveSubTabIndex;

  void setTabIndex(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void setLiveSubTabIndex(int index) {
    if (_selectedLiveSubTabIndex != index) {
      _selectedLiveSubTabIndex = index;
      notifyListeners();
    }
  }

  void reset() {
    _selectedTabIndex = 0;
    _selectedLiveSubTabIndex = 0;
    notifyListeners();
  }
}