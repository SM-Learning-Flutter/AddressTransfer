
import 'package:address_transfer/ui/screens/main_google_map_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MainGoogleMapPage(),
    );
  }
}