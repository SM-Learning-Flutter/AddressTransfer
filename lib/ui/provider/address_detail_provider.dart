
import 'package:flutter/cupertino.dart';

class AddressDetailProvider extends ChangeNotifier {
  String _title = "";
  String _address = "";
  String _dodobuken = "";
  String _shiChouSon = "";
  String _etcAddress = "";
  String _locationName = "";
  String _phoneNum = "";

  String get title => _title;
  String get address => _address;
  String get dodobuKen => _dodobuken;
  String get shiChouSon => _shiChouSon;
  String get etcAddress => _etcAddress;
  String get locationName => _locationName;
  String get phoneNum => _phoneNum;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setDodobuKen(String dodobuKen) {
    _dodobuken = dodobuKen;
    notifyListeners();
  }

  void setShiChouSon(String shiChouSon) {
    _shiChouSon = shiChouSon;
    notifyListeners();
  }

  void setEtcAddress(String etcAddress) {
    _etcAddress = etcAddress;
    notifyListeners();
  }

  void setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void setPhoneNum(String phoneNum) {
    _phoneNum = phoneNum;
    notifyListeners();
  }
}