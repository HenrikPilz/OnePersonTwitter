import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:one_person_twitter/models/tweet.dart';

abstract class HomeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAllTweets extends HomeEvents {}

class DeleteTweet extends HomeEvents {
  final String tweetId;
  DeleteTweet({
    @required this.tweetId,
  });
}

class StartTweetListener extends HomeEvents {}

class PostTweet extends HomeEvents {
  final Tweet tweet;
  PostTweet({
    @required this.tweet,
  });
}

class UpdateTweet extends HomeEvents {
  final Tweet tweet;
  UpdateTweet({
    this.tweet,
  });
}
