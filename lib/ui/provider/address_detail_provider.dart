import 'package:flutter/cupertino.dart';

class AddressDetailProvider {
  String _title = "";
  String _address = "";

  String get title => _title;
  String get address => _address;

  void setTitle(String title) {
    _title = title;
  }

  void setAddress(String address) {
    _address = address;
  }
}
