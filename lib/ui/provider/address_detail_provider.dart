import 'package:flutter/cupertino.dart';

class AddressDetailProvider extends ChangeNotifier {
  List<String> _title = [];
  List<String> _address = [];
  List<String> _dodobuken = [];
  List<String> _shiChouSon = [];
  List<String> _etcAddress = [];
  List<String> _locationName = [];
  List<String> _phoneNum = [];

  List<String> get title => _title;
  List<String> get address => _address;
  List<String> get dodobuKen => _dodobuken;
  List<String> get shiChouSon => _shiChouSon;
  List<String> get etcAddress => _etcAddress;
  List<String> get locationName => _locationName;
  List<String> get phoneNum => _phoneNum;

  void setTitle(String title) {
    _title.add(title);
    notifyListeners();
  }

  void setAddress(String address) {
    _address.add(address);
    notifyListeners();
  }

  void setDodobuKen(String dodobuKen) {
    _dodobuken.add(dodobuKen);
    notifyListeners();
  }

  void setShiChouSon(String shiChouSon) {
    _shiChouSon.add(shiChouSon);
    notifyListeners();
  }

  void setEtcAddress(String etcAddress) {
    _etcAddress.add(etcAddress);
    notifyListeners();
  }

  void setLocationName(String locationName) {
    _locationName.add(locationName);
    notifyListeners();
  }

  void setPhoneNum(String phoneNum) {
    _phoneNum.add(phoneNum);
    notifyListeners();
  }

  void clearAddressInfo() {
    _title.clear();
    _address.clear();
    _dodobuken.clear();
    _etcAddress.clear();
    _locationName.clear();
    _phoneNum.clear();
    _shiChouSon.clear();
  }
}
