import 'dart:io';

class SignedinUser {
  String firstName;
  String lastName;
  late String uId;
  String phoneNumber;
  String email;
  String password;
  String profile;

  SignedinUser(
      {required this.firstName,
      required this.lastName,
      required this.password,
      required this.phoneNumber,
      required this.profile,
      required this.email});

  //map of user information
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'firsName': firstName,
      'lastName': lastName,
      'profile': profile,
    };
  }
}
