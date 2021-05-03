import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/models/profile.dart';

abstract class AuthenticationStates extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AuthenticationStates {}

class LoadingState extends AuthenticationStates {}

class AuthenticationFailureState extends AuthenticationStates {
  final String errorMessage;

  AuthenticationFailureState({
    this.errorMessage,
  });
}

class ProfileFetchSuccessState extends AuthenticationStates {
  final Profile profile;

  ProfileFetchSuccessState({
    @required this.profile,
  });
}

class SignUpSuccessState extends AuthenticationStates {}

class SignInSuccessState extends AuthenticationStates {}

class SignOutSuccessState extends AuthenticationStates {}
