import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/app.dart';
import 'package:one_person_twitter/service_locators/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpLocator();
  runApp(MyApp());
}
