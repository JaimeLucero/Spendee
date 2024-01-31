import 'package:flutter/material.dart';
import 'package:spendee/Pages/login_page.dart';
import 'package:spendee/Pages/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  //show the login page initially
  bool showLoginPage = true;

  //toggle between login and signup page
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePage);
    } else {
      return SignupPage(onTap: togglePage);
    }
  }
}
