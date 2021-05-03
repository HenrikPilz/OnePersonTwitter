import 'package:flutter/material.dart';
import 'package:one_person_twitter/routes/route_geneartor.dart';
import 'package:one_person_twitter/routes/route_names.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue[800],
      accentColor: Colors.cyan[800],
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.blue[700],
        ),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headline2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        headline3: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        headline6: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: SplashRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => UndefinedView(),
      ),
      theme: themeData,
    );
  }
}

class UndefinedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  }
}
