
import 'package:flutter/cupertino.dart';

class AddressDetailProvider extends ChangeNotifier {
  bool _visibility = false;
  String _title = "";
  String _address = "";

  bool get visibility => _visibility;
  String get title => _title;
  String get address => _address;

  void setVisibility(bool visibility) {
    _visibility = visibility;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
}