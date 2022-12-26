
import 'dart:collection';
import 'dart:convert';

import 'package:address_transfer/model/location.dart';
import 'package:address_transfer/ui/provider/address_detail_provider.dart';
import 'package:address_transfer/ui/widgets/border_text_field.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../widgets/address_detail_widget.dart';

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
  
  List<Marker> _markers = [];
  List<Location> locations = [];

  int placeCount = 0;
  double latPosition = 35.7013120;
  double lngPosition = 139.7747018;

  final PanelController _panelController = PanelController();

  String title = "";
  
  Widget detailInfo(LatLng target) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        children: [
          SimpleTextWidget(text: "Latitude ::${target.latitude}", fontSize: 24),
          SimpleTextWidget(text: "Longitude :: ${target.longitude}", fontSize: 24,)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _updatePosition(CameraPosition _position) {
    latPosition = _position.target.latitude;
    lngPosition = _position.target.longitude;
  }

  void _setMarker(double lat, double lng, String placeId, int index) {
    _markers.add(
      Marker(
        markerId: MarkerId(index.toString()),
        position: LatLng(lat, lng),
        draggable: false,
        onTap: () {
          getPlaceInfo(placeId);
        }
      )
    );
  }

  void getPlaceId() async {
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latPosition,$lngPosition&key=${FlutterConfig.get('apiKey')}';
    final response = await http.get(Uri.parse(gpsUrl));
    print("테스트1 :: $gpsUrl");
    if(response.statusCode == 200){
      // getPlaceInfo(jsonDecode(response.body)['results'][0]['place_id']);
      _markers.clear();
      locations.clear();
      for (var item in jsonDecode(response.body)['results']) {
        var location = item["geometry"]["location"];
        locations.add(Location(location["lat"], location["lng"], item['place_id']));
      }
      int index = 0;
      locations.forEach((element) {
        _setMarker(element.lat, element.lng, element.placeId, index);
        index++;
      });
      setState(() {
      });
      placeCount = locations.length;
    } else {
      _addressDetailProvider.setTitle('api error');
      throw Exception('Failed to load album');
    }
  }

  void getPlaceInfo(String placeId) async {
      String placeUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${FlutterConfig.get('apiKey')}";
      print("테스트2 :: $placeUrl");
      final response = await http.get(Uri.parse(placeUrl));

      if (response.statusCode == 200) {
        _addressDetailProvider.setTitle(jsonDecode(response.body)["result"]["name"]);
        _addressDetailProvider.setAddress(jsonDecode(response.body)["result"]["formatted_address"]);
        
        _addressDetailProvider.setLocationName(jsonDecode(response.body)["result"]["name"]);
        _addressDetailProvider.setPhoneNum(jsonDecode(response.body)["result"]["international_phone_number"]);
      }  else {
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