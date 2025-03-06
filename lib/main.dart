import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:my_new/app/app.dart';
import 'package:my_new/app/di/di.dart';
import 'package:my_new/core/network/hive_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Initialize Hive Database
  await HiveService.init();

  // Delete all the hive data and boxes
  // await HiveService().clearAll();
  // Initialize Dependencies
  await initDependencies();

  runApp(const App());
}
