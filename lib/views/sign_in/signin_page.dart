import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:one_person_twitter/blocs/authentication/auth_bloc.dart';
import 'package:one_person_twitter/blocs/authentication/auth_event.dart';
import 'package:one_person_twitter/blocs/authentication/auth_state.dart';
import 'package:one_person_twitter/routes/route_names.dart';
import 'package:one_person_twitter/helper/validator.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _signInFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationStates>(
        listener: (context, state) {
          if (state is AuthenticationFailureState) {
            final snackBar = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is SignInSuccessState) {
            final snackBar = SnackBar(
                duration: const Duration(milliseconds: 1000),
                content: Text('Sign in successful!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.pushReplacementNamed(context, HomeRoute);
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Stack(
              children: [
                singInForm(context),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFF696969).withOpacity(0.5),
                ),
                SpinKitFadingCircle(
                  color: Colors.black,
                )
              ],
            );
          }
          return singInForm(context);
        },
      ),
    );
  }

  Form singInForm(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
              ),
              validator: (value) => Validator().checkEmail(email: value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (value) => Validator().checkEmpty(value: value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: ElevatedButton(
                onPressed: _onSignIn,
                child: Text('Sign In'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _onCreateAnAccount,
              child: Text('Create an account'),
            ),
          )
        ],
      ),
    );
  }

  _onSignIn() {
    if (!_signInFormKey.currentState.validate()) {
      return;
    }
    _authenticationBloc.add(SingInEvent(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    ));
  }

  _onCreateAnAccount() {
    Navigator.pushNamed(context, SignupRoute);
  }
}
