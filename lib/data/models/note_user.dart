import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class NoteUser {
  final String displayName;
  final String email;
  final String profileImageUrl;
  final bool darkMode;

  NoteUser({
    required this.displayName,
    required this.email,
    required this.profileImageUrl,
    required this.darkMode,
  });

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'darkMode': darkMode,
      };

  NoteUser.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        email = json['displayName'],
        profileImageUrl = json['profileImageUrl'],
        darkMode = json['darkMode'];
  // Map<String, dynamic> toJson() => _userToJson(this);

  // User _userFromJson(Map<String, dynamic> json) {
  //   return User(
  //       displayName: json['displayName'] as String,
  //       email: json['email'] as String,
  //       profileImageUrl: json['profileImageUrl'] as String,
  //       darkMode: json['darkMode'] as bool);
  //   // tasks: tasks.map((task) => Task.fromJson(task)).toList()
  //   // tasks: _convertTask(json['tasks'] as List<dynamic>));
  // }
}
