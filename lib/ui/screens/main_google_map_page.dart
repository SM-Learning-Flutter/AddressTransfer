
import 'package:address_transfer/ui/provider/address_detail_provider.dart';
import 'package:address_transfer/ui/widgets/border_text_field.dart';
import 'package:address_transfer/ui/widgets/simple_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

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
        _addressDetailProvider.setTitle(title);
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          minHeight: 56.h,
          maxHeight: 150.h,
          controller: _panelController,
          body: mainGoogleMapWidget(),
        )
      ),
    );
  }
}

