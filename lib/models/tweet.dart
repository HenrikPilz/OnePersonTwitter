import 'package:flutter/material.dart';
import 'package:one_person_twitter/models/profile.dart';

class Tweet {
  final DateTime time;
  final String id;
  String message;
  final Profile postedBy;

  Tweet({
    @required this.time,
    @required this.message,
    @required this.postedBy,
    this.id,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) => Tweet(
        time: json['time'],
        message: json['message'],
        id: json['id'],
        postedBy: Profile.fromJson(json['postedBy']),
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'message': message,
        'postedBy': postedBy.toJson(),
      };
}
