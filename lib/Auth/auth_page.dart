import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spendee/Pages/home_page.dart';
import 'package:spendee/Pages/login_or_signup_page.dart';
import 'package:spendee/Pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if user is signed in
            return HomePage();
          } else {
            //if user is not signed int
            return LoginOrSignupPage();
          }
        },
      ),
    );
  }
}
