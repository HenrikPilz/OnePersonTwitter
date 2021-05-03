import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/models/profile.dart';
import 'package:one_person_twitter/models/tweet.dart';

abstract class HomeStates extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class TweetPostingState extends HomeStates {}

class PostSuccessState extends HomeStates {}


class FailureState extends HomeStates {
  final String errorMessage;

  FailureState({
    this.errorMessage,
  });
}

class FetchSuccessState extends HomeStates {
  final List<Tweet> tweets;

  FetchSuccessState({this.tweets});
}
