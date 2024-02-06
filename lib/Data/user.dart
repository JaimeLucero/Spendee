
class SignedinUser {
  String firstName;
  String lastName;
  late String uId;
  String phoneNumber;
  String email;
  String profile;

  SignedinUser(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.profile,
      required this.email});

  //map of user information
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'profile': profile,
    };
  }
}
