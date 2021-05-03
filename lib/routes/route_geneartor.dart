import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_person_twitter/blocs/authentication/auth_bloc.dart';
import 'package:one_person_twitter/blocs/home/home_bloc.dart';
import 'package:one_person_twitter/routes/route_names.dart';
import 'package:one_person_twitter/views/home/home_page.dart';
import 'package:one_person_twitter/views/sign_in/signin_page.dart';
import 'package:one_person_twitter/views/sign_up/signup_page.dart';
import 'package:one_person_twitter/views/splash_screen/splash_screen.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignupRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (BuildContext context) => AuthenticationBloc(),
            child: SignUpPage(),
          ),
        );
      case SigninRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (BuildContext context) => AuthenticationBloc(),
            child: SignInPage(),
          ),
        );
      case HomeRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (BuildContext context) => HomeBloc(),
              ),
              BlocProvider<AuthenticationBloc>(
                create: (BuildContext context) => AuthenticationBloc(),
              ),
            ],
            child: HomePage(),
          ),
        );
      case SplashRoute:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
    }
  }
}
