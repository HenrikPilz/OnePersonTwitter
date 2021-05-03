import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SingUpEvent extends AuthenticationEvents {
  final String email;
  final String password;
  final File profileImageFile;
  final String name;

  SingUpEvent({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.profileImageFile,
  });
}

class GetUserProfile extends AuthenticationEvents {}

class SingInEvent extends AuthenticationEvents {
  final String email;
  final String password;

  SingInEvent({
    @required this.email,
    @required this.password,
  });
}

class SignOutEvent extends AuthenticationEvents {}
