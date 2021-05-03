import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:one_person_twitter/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      redirect();
    });
  }

  redirect() async {
    if (FirebaseAuth.instance.currentUser != null) {
      navigateToHome();
    } else {
      navigateToLogin();
    }
  }

  navigateToHome() {
    Navigator.pushReplacementNamed(context, HomeRoute);
  }

  navigateToLogin() {
    Navigator.pushReplacementNamed(context, SigninRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SpinKitFadingFour(
            color: Colors.black,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
