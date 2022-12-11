
import 'package:address_transfer/ui/widgets/border_text_field.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../model/geoApi.dart';
import 'dart:developer';
import 'package:logger/logger.dart';

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
  List<Marker> _markers = [];
  List<String> _geo = ['test'];
  int count = 0;

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
        infoWindow: InfoWindow(title: _position.target.toString(),)
      ),
    );
    setState(() {});
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
      onCameraMove: ((_position) => _updatePosition(_position)),
      onCameraIdle: () {
        // 카메라 이동이 멈춘 경우
        var logger = Logger(
          printer: PrettyPrinter(),
        );
        logger.d('Log message with 2 methods');
        showShortHeightModalBottomSheet(context);
      },
    );
  }

  void showShortHeightModalBottomSheet(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      enableDrag: true,
      bounce: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return SizedBox(
          // SizedBox로 감싸고 height로 높이를 설정.
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FutureBuilder(
                    future: getMarker(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      }
                      //error가 발생하게 될 경우 반환하게 되는 부분
                      else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }
                      // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                      else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        );
                      }
                    }),
                ElevatedButton(
                  child: Text('cancel'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> getMarker() async {

    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_markers.last.position.latitude},${_markers.last.position.longitude}&key=${FlutterConfig.get('apiKey')}';

    final response = await http.get(Uri.parse(gpsUrl));

    if(response.statusCode == 200){
      _geo.add(jsonDecode(response.body)['results'][0]['formatted_address']);
      return jsonDecode(response.body)['results'][0]['formatted_address'];
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
        ),

      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: const Color(0xffb6ffa9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                              FutureBuilder(
                              future: getMarker(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                if (snapshot.hasData == false) {
                                  return CircularProgressIndicator();
                                }
                                //error가 발생하게 될 경우 반환하게 되는 부분
                                else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                }
                                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                }
                              }),
                              ElevatedButton(
                                child: Text('cancel'),
                                onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  );
                },
            );
          },
          label: const SimpleTextWidget(text: "주소 변환", fontSize: 16,)),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

