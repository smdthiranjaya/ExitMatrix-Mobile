import 'dart:io';

import 'package:flutter/foundation.dart';

class User {
  String email;

  String name;

  String lastName;
  String role;
  String age;
  String gender;
  String address;

  String doctorId;

  String userID;

  String image_url;

  String appIdentifier;

  User(
      {this.email = '',
      this.name = '',
      this.lastName = '',
      this.role = '',
      this.doctorId = '',
      this.age = '',
      this.gender = '',
      this.address = '',
      this.userID = '',
      this.image_url = ''})
      : appIdentifier = 'PoochPaw ${kIsWeb ? 'Web' : Platform.operatingSystem}';

  String fullName() => '$name $lastName';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson['email'] ?? '',
        name: parsedJson['name'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        role: parsedJson['role'] ?? '',
        doctorId: parsedJson['doctorId'] ?? '',
        age: parsedJson['age'] ?? '',
        gender: parsedJson['gender'] ?? '',
        address: parsedJson['address'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        image_url: parsedJson['image_url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'role': role,
      'doctorId': doctorId,
      'age': age,
      'gender': gender,
      'address': address,
      'id': userID,
      'image_url': image_url,
      'appIdentifier': appIdentifier
    };
  }
}
