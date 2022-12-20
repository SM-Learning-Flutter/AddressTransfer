import 'package:address_transfer/ui/widgets/border_text_field.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/address_detail_widget.dart';
import '../provider/address_detail_provider.dart';

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
  bool _flag = false;

  Widget detailInfo(LatLng target) {
    return Container(
      height: 120.h,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          SimpleTextWidget(text: "Latitude ::${target.latitude}", fontSize: 24),
          SimpleTextWidget(
            text: "Longitude :: ${target.longitude}",
            fontSize: 24,
          )
        ],
      ),
    );
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
    var m =
        _markers.firstWhere((p) => p.markerId == MarkerId('1'), orElse: null);
    _markers.remove(m);
    _markers.add(
      Marker(
          markerId: MarkerId('1'),
          position:
              LatLng(_position.target.latitude, _position.target.longitude),
          draggable: true,
          onTap: () {
            setState(() {
              _flag = _flag ? false : true;
            });
          }),
    );
    setState(() {});
  }

  Future<dynamic> getDetails() async {
    _addressDetailProvider.setTitle('데이터 가져오는 중..');
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_markers.last.position.latitude},${_markers.last.position.longitude}&key=AIzaSyBXqmRU8SZMvY4QJGGUpz_UXumuxfY6O-o');
    final placeIdRes = await http.get(uri);

    if (placeIdRes.statusCode == 200) {
      String placeId = jsonDecode(placeIdRes.body)['results'][0]['place_id'];

      Uri uri = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyBXqmRU8SZMvY4QJGGUpz_UXumuxfY6O-o");
      final resultRes = await http.get(uri);

      if (resultRes.statusCode == 200) {
        dynamic result = jsonDecode(resultRes.body)["result"];
        _addressDetailProvider.setTitle(result["name"]);
        _addressDetailProvider.setAddress(result["formatted_address"]);
      } else {
        _addressDetailProvider.setTitle("api error");
        _addressDetailProvider.setAddress("api error");
      }
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
        ));
  }

  Widget googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set.from(_markers),
      initialCameraPosition: MainGoogleMapPage._kGooglePlex,
      myLocationButtonEnabled: false,
      onCameraMove: (_position) => {
        _updatePosition(_position),
        setState(() {
          _flag = false;
        }),
      },
      onCameraIdle: () => {
        getDetails(),
      },
    );
  }

  Widget AddressDetail(minHeight, maxHeight) {
    return SlidingUpPanel(
      panel: AddressDetailWidget(),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      minHeight: minHeight,
      maxHeight: maxHeight,
      body: mainGoogleMapWidget(),
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
    return Scaffold(
      body: SafeArea(
        child: _flag ? AddressDetail(95.h, 340.h) : AddressDetail(56.h, 340.h),
      ),
    );
  }
}
