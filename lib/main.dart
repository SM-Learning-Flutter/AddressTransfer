
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //추가
  await FlutterConfig.loadEnvVariables(); //추가
  runApp(const App());
}

