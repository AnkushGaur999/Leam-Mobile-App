import 'package:flutter/material.dart';
import 'package:leam/src/config/di/service_locator.dart';
import 'package:leam/src/my_app.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();


  runApp(const MyApp());
}




