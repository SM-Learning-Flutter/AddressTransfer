
import 'dart:convert';

import 'package:address_transfer/ui/provider/address_detail_provider.dart';
import 'package:address_transfer/ui/widgets/border_text_field.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'dart:convert';
import '../../model/geoApi.dart';
import 'dart:developer';
import 'package:logger/logger.dart';

import '../widgets/address_detail_widget.dart';

//위도,경도 -> 장소id -> 장소검색
class MainGoogleMapPage extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.7013120, 139.7747018),
    zoom: 14.4746,
  );


  MainGoogleMapPage({Key? key}) : super(key: key);

  @override
  State<MainGoogleMapPage> createState() => _MainGoogleMapPageState();
}

class _MainGoogleMapPageState extends State<MainGoogleMapPage> {
  late AddressDetailProvider _addressDetailProvider;
  List<String> _geo = ['test'];
  List<Marker> _markers = [];
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final PanelController _panelController = PanelController();
  var totalAddress;
  String title = "";
  
  Widget detailInfo(LatLng target) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        children: <Widget>[
          SimpleTextWidget(text: "Latitude ::${target.latitude}", fontSize: 24),
          SimpleTextWidget(text: "Longitude :: ${target.longitude}", fontSize: 24,)
        ],
      ),
    );
  }


  void getMarker() async {
    _addressDetailProvider.setTitle('loading');
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_markers.last.position.latitude},${_markers.last.position.longitude}&key=${FlutterConfig.get('apiKey')}';
    final response = await http.get(Uri.parse(gpsUrl));

    if(response.statusCode == 200){
      totalAddress = jsonDecode(response.body)['results'][0]['address_components'];
      logger.i(totalAddress);
      _addressDetailProvider.setTitle(jsonDecode(response.body)['results'][0]['formatted_address']);
      _addressDetailProvider.setDodobuKen(totalAddress);
    } else {
      _addressDetailProvider.setTitle('api error');
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: LatLng(35.7013120, 139.7747018)));
  }

  void _updatePosition(CameraPosition _position) {
    var m = _markers.firstWhere((p) => p.markerId == MarkerId('1'),
        orElse: null);
    _markers.remove(m);
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
        onTap: () {
          _panelController.show();
        }
      ),
    );
    setState(() {
    });
  }

  void getPlaceId() async {

    logger.i(_markers.last.position.latitude);
    logger.i(_markers.last.position.longitude);
    _addressDetailProvider.setTitle('loading');
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_markers.last.position.latitude},${_markers.last.position.longitude}&key=${FlutterConfig.get('apiKey')}';
    final response = await http.get(Uri.parse(gpsUrl));
    // print("테스트1 :: $gpsUrl");
    if(response.statusCode == 200){

      getPlaceInfo(jsonDecode(response.body)['results'][0]['place_id']);
    } else {
      _addressDetailProvider.setTitle('api error');
      throw Exception('Failed to load album');
    }
  }

  void getPlaceInfo(String placeId) async {
    _addressDetailProvider.setTitle('loading');
      String placeUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${FlutterConfig.get('apiKey')}";
      // print("테스트2 :: $placeUrl");
      final response = await http.get(Uri.parse(placeUrl));
      String shiChouSon = "";
      String etcAddress = "";
      if (response.statusCode == 200) {
        totalAddress = jsonDecode(response.body)['result']['address_components'];
        // logger.i("위치 : $totalAddress");
        for (var address in totalAddress.reversed.toList()) {
          switch (address["types"][0]) {
            case 'country':
              logger.i("나라 : ${address['long_name']}");
              break;
            case 'administrative_area_level_1':
              _addressDetailProvider.setDodobuKen(address['long_name']);
              break;
            case 'locality':
              shiChouSon = "${shiChouSon + address['long_name']} ";
              logger.i(shiChouSon);
              break;
            case 'sublocality_level_1':
              shiChouSon = "${shiChouSon + address['long_name']} ";
              logger.i(shiChouSon);
              break;
            case 'sublocality_level_2':
              shiChouSon = "${shiChouSon + address['long_name']} ";
              logger.i(shiChouSon);
              break;
            case 'sublocality_level_3':
              etcAddress = "${etcAddress + address['long_name']} ";
              logger.i('sublocality_level_3');
              break;
            case 'sublocality_level_4':
              logger.i('sublocality_level_4');
              etcAddress = "${etcAddress + address['long_name']} ";
              break;
            case 'premise':
              etcAddress = "${etcAddress + address['long_name']} ";
              logger.i('premise');
              break;
            default:
              logger.i("default : $address");
              break;
          }
        }
        _addressDetailProvider.setTitle(jsonDecode(response.body)["result"]["name"]);
        _addressDetailProvider.setLocationName(jsonDecode(response.body)["result"]["name"]);
        _addressDetailProvider.setPhoneNum(jsonDecode(response.body)["result"]["international_phone_number"]);

        _addressDetailProvider.setShiChouSon(shiChouSon);
        _addressDetailProvider.setEtcAddress(etcAddress);
      }  else {
        logger.i("위치 api 에러");
        _addressDetailProvider.setTitle('api error');
        throw Exception('Failed to load album');
      }
  }

  Widget searchBarWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: const BorderTextField(
        labelFontSize: 24,
        labelText: "주소 검색",
        borderColor: Colors.white60,
        borderRadius: BorderRadius.all(Radius.circular(36)),
      )
    );
  }
  
  Widget googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set.from(_markers),
      initialCameraPosition: MainGoogleMapPage._kGooglePlex,
      myLocationButtonEnabled: false,
      onCameraMoveStarted: () {
        _panelController.close();
      },
      onCameraMove: (_position) => {
        _updatePosition(_position),
        title = _position.target.latitude.toString()
      },
      onCameraIdle: () {
        // _addressDetailProvider.setTitle(title);
        getPlaceId();
      },
    );
  }

  Widget mainGoogleMapWidget() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              heightFactor: 0.3,
              widthFactor: 2.5,
              child: googleMap(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: searchBarWidget(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _addressDetailProvider = Provider.of<AddressDetailProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          panel: AddressDetailWidget(),
          header: Container(),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          minHeight: 56.h,
          maxHeight: 550.h,
          controller: _panelController,
          body: mainGoogleMapWidget(),
        )
      ),
    );
  }
}

