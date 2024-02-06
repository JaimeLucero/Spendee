import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendee/Data/User.dart';
import 'package:spendee/Data/firestore_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SignedinUser?>? signedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signedUser = initializeUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000111),
      body: FutureBuilder<SignedinUser?>(
          future: signedUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for authentication state
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DASHBOARD',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 32, 
                              fontWeight: FontWeight.w900, 
                              fontStyle: FontStyle.italic),
                          ),
                          IconButton(
                            onPressed: signOutUser,
                             icon: ClipOval(
                              child: Image.network(
                                snapshot.data!.profile,
                                width: 50,
                                height: 50,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Text("User Logged In"),
                    Text(snapshot.data!.toJson().toString())
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text("Sign up error"),
                content: Text("Error: ${snapshot.error}"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      signOutUser();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: const Text("Sign up error"),
                content: const Text("Unkown error"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      signOutUser();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            }
          }),
    );
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<SignedinUser?> initializeUser(BuildContext context) async {
    try {
      print(widget.user.toString());

      if (widget.user != null) {
        String email = widget.user!.email!;
        String uid = widget.user!.uid;

        Map<String, dynamic>? userData =
            await FirebaseService().getDocument('users', email);
        print(userData.toString());

        if (userData != null) {
          print('data retrieved');
        } else {
          print('no data');
        }

        SignedinUser signedUser = SignedinUser(
          firstName: userData!['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          phoneNumber: userData['phoneNumber'] ?? '',
          profile: userData['profile'] ?? '',
          email: email,
        );
        signedUser.uId = uid;
        return signedUser;
      } else {
        print('No user');
      }
    } catch (e) {
      print("Error initializing user: $e");
      // Handle error if necessary
    }
    return null;
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
}
