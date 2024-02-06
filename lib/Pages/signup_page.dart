import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:spendee/Data/firestore_service.dart';
import 'package:spendee/Data/user.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //user info
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNumber = TextEditingController();
  late String completePhoneNumber;
  DateTime _birthday = DateTime.now();
  final int _currentYear = DateTime.now().year;
  late String _profileUrl;
  late SignedinUser user;

  //booleans for input validation
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isPhoneValid = true;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool isUserAddedToFirestore = false;
  bool isProfileSavedToFirestore = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordConfirmController.dispose();
    _passwordController.dispose();
    _phoneNumber.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000111),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Column(
              children: <Widget>[
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundImage:
                            image != null ? FileImage(image!) : null,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 60,
                        child: IconButton(
                          onPressed: () => pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 400,
                  width: 270,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      TextField(
                        controller: _firstName,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'First Name',
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _lastName,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: TextEditingController(
                          text: _birthday == null
                              ? 'Select Date'
                              : '${_birthday.day}/${_birthday.month}/${_birthday.year}',
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectBirthday(context);
                            },
                          ),
                          hintText: 'Birthday',
                          hintStyle: const TextStyle(color: Colors.white54),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'DD/MM/YYYY',
                          style: TextStyle(color: Colors.white30, fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      IntlPhoneField(
                        controller: _phoneNumber,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        initialCountryCode: 'PH',
                        style: const TextStyle(color: Colors.white),
                        dropdownTextStyle: const TextStyle(color: Colors.white),
                        onChanged: (phone) {
                          _validatePhoneNumber(
                              '${phone.countryCode}${phone.number}');
                        },
                      ),
                      TextField(
                        controller: _emailController,
                        onChanged: _validateEmail,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white54),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          errorText:
                              _isEmailValid ? null : 'Invalid email format',
                          errorStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _passwordController,
                        obscureText: _obscurePass,
                        onChanged: _validatePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePass = !_obscurePass;
                                });
                              }),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          errorText: _isPasswordValid
                              ? null
                              : 'Password must be 8 or more characters',
                          errorStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _passwordConfirmController,
                        obscureText: _obscureConfirmPass,
                        onChanged: _validateConfirmPassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPass = !_obscureConfirmPass;
                                });
                              }),
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          errorText: _isConfirmPasswordValid
                              ? null
                              : 'Password must be 8 or more characters',
                          errorStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: signUpUser,
                  child: Container(
                    width: 165,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFF1916D),
                    ),
                    child: const Center(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Already a member?  ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.blue.shade300,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  //Image picker for user's profile picture
  File? image;
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  //user sign up method
  Future<void> signUpUser() async {
    // Check if passwords match
    if (_passwordController.text == _passwordConfirmController.text) {
      // check if inputted email is valid
      if (_isEmailValid) {
        //check if inputted password is valid
        if (_isPasswordValid) {
          if (isOlderThan16(_birthday)) {
            //check if phone number input is valid
            if (_isPhoneValid) {
              // if input is valid try to create the user
              try {
                // Display loading circle
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                // Upload profile image to Firebase Storage
                try {
                  _profileUrl =
                      await FirebaseService().uploadImageToFirebase(image!);
                  isProfileSavedToFirestore = true;
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  showErrorMessage(context, e.toString());
                }

                // Initialize user object
                user = SignedinUser(
                  firstName: capitalizeFirstLetter(_firstName.text),
                  lastName: capitalizeFirstLetter(_lastName.text),
                  phoneNumber: completePhoneNumber,
                  profile: _profileUrl,
                  email: _emailController.text,
                );

                // Add user to Firestore
                if (isProfileSavedToFirestore) {
                  try {
                    await FirebaseService().addUserToFirestore(user);
                    isUserAddedToFirestore = true;
                  } catch (e) {
                    showErrorMessage(context, e.toString());
                  }
                }

                // Create user with email and password if user info is added to firestore
                if (isUserAddedToFirestore) {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  // The user is created successfully, and you can now access the UID
                  String uid = userCredential.user!.uid;

                  // Set the UID as the document ID in Firestore
                  user.uId = uid;
                }
                // Dismiss loading circle
                Navigator.pop(context);
              } catch (e) {
                // Error occurred during sign-up, show error message
                Navigator.pop(context);
                showErrorMessage(context, e.toString());
              }
            } else {
              showErrorMessage(context, 'Invalid phone number');
            }
          } else {
            // show message for required age
            showErrorMessage(context, 'You need to be 16 or older.');
          }
        } else {
          // error message for invalid password
          showErrorMessage(context, 'Invalid password');
        }
      } else {
        // error message for invalid email
        showErrorMessage(context, 'Invalid email');
      }
    } else {
      // Passwords don't match, show error message
      showErrorMessage(context, "Password does not match!");
    }
  }

  //show error in a snackbar
  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2), // Adjust duration as needed
      ),
    );
  }

  //email input validation
  void _validateEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  //password input validation
  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = password.length >= 8;
    });
  }

  //confirm password input validation
  void _validateConfirmPassword(String password) {
    setState(() {
      _isConfirmPasswordValid = password.length >= 8;
    });
  }

  //date selector for birthday
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(_currentYear - 100),
      lastDate: DateTime(_currentYear + 5),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  //validate inputted phone number
  void _validatePhoneNumber(String phone) {
    setState(() {
      print(phone);
      String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
      var regExp = RegExp(regexPattern);

      //check if phone number is correct length and matches regex
      if (_phoneNumber.text.length < 10) {
        _isPhoneValid = false;
      } else if (regExp.hasMatch(phone)) {
        completePhoneNumber = phone;
        _isPhoneValid = true;
      } else {
        _isPhoneValid = false;
      }
    });
  }

  //validate user's age if they are 16 or older
  bool isOlderThan16(DateTime selectedBirthday) {
    // Calculate today's date
    DateTime today = DateTime.now();

    // Calculate the difference in years between today's date and the selected birthday
    int age = today.year - selectedBirthday.year;

    // If the user hasn't had their birthday yet this year, subtract 1 from age
    if (today.month < selectedBirthday.month ||
        (today.month == selectedBirthday.month &&
            today.day < selectedBirthday.day)) {
      age--;
    }

    // Check if the calculated age is greater than 16
    return age >= 16;
  }

  //to capitalize the first letter of the user's name
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text; // Return empty string if input is empty
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
