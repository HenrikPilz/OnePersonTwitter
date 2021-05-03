import 'package:flutter/material.dart';

class Profile {
  final String id;
  final String name;
  final String profileImagePath;

  Profile({
    @required this.id,
    @required this.name,
    @required this.profileImagePath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        name: json['name'],
        profileImagePath: json['profileImagePath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileImagePath': profileImagePath,
      };
}
