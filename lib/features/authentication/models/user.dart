import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String firstname;
  String lastname;
  final String username;
  final String email;
  final String phone;
  final String? profilePicture;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phone,
    this.profilePicture,
  });

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
    );
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();
      return User(
        id: document.id,
        firstname: data?['firstname'] ?? '',
        lastname: data?['lastname'] ?? '',
        username: data?['username'] ?? '',
        email: data?['email'] ?? '',
        phone: data?['phone'] ?? '',
        profilePicture: data?['profilePicture'] ?? '',
      );
    } else {
      return User.empty();
    }
  }

  // Convert User instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
    };
  }

  static User empty() {
    return User(
      id: '',
      firstname: '',
      lastname: '',
      username: '',
      email: '',
      phone: '',
      profilePicture: '',
    );
  }

  String get fullName => '$firstname $lastname';

  static List<String> nameParts(fullname) => fullname.split(" ");

  static String generateUsername(fullname) {
    List<String> nameParts = fullname.split(" ");
    String firstname = nameParts[0].toLowerCase();
    String lastname = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstname$lastname";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  // Helper method to convert User to a JSON string
  String toJsonString() => jsonEncode(toJson());

  // Helper method to create a User from a JSON string
  static User fromJsonString(String jsonString) =>
      User.fromJson(jsonDecode(jsonString));
}
