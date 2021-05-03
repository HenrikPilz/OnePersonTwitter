import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_person_twitter/blocs/authentication/auth_bloc.dart';
import 'package:one_person_twitter/blocs/authentication/auth_event.dart';
import 'package:one_person_twitter/blocs/authentication/auth_state.dart';
import 'package:one_person_twitter/routes/route_names.dart';
import 'package:one_person_twitter/helper/validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  File _displayImage;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
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
          } else if (state is SignUpSuccessState) {
            final snackBar =
                SnackBar(content: Text('Account created! Please logn'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SigninRoute,
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Stack(
              children: [
                singUpForm(context),
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
          return singUpForm(context);
        },
      ),
    );
  }

  Widget singUpForm(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: _selectImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: (_displayImage == null)
                  ? Image.asset(
                      'assets/images/placeholder.jpeg',
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      _displayImage,
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextFormField(
              controller: _nameTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              validator: (value) => Validator().checkEmpty(value: value),
            ),
          ),
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
              validator: (value) =>
                  Validator().checkPasswordStrength(password: value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: ElevatedButton(
                onPressed: _onSignUp,
                child: Text('Sign Up'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Already have an account? Sign in'),
            ),
          )
        ],
      ),
    );
  }

  _onSignUp() {
    if (!_signUpFormKey.currentState.validate()) {
      return;
    }
    if (_displayImage == null) {
      final snackBar = SnackBar(content: Text('Please select a profile image'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    BlocProvider.of<AuthenticationBloc>(context).add(
      SingUpEvent(
        name: _nameTextController.text,
        email: _emailTextController.text,
        password: _passwordTextController.text,
        profileImageFile: _displayImage,
      ),
    );
  }

  _selectImage() {
    showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Choose image source'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          )
        ],
      ),
    ).then((ImageSource source) async {
      if (source != null) {
        final pickedFile = await ImagePicker().getImage(source: source);
        setState(() => _displayImage = File(pickedFile.path));
      }
    });
  }
}
