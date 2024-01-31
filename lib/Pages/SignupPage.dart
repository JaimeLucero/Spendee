import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignupPageWidget(),
        backgroundColor: Color(0xFF000111),
      ),
    );
  }
}

class SignupPageWidget extends StatefulWidget {
  const SignupPageWidget({super.key});

  @override
  State<SignupPageWidget> createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } catch (e) {
      print('Image select fail.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 100),
          const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: <Widget>[
              const Text(
                'Profile',
                style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
                child: image != null
                    ? ClipOval(
                        child: Image.file(
                          image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox(
                        height: 20,
                      ),
              ),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                child: const Text('Select Image'),
              ),
              const SizedBox(
                height: 350,
                width: 270,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Birthday',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ), 
                    SizedBox(height: 10,),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ), 
                    SizedBox(height: 10,),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
              width: 165,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFF1916D),
              ),
              child: const Center(
                child: Text(
                  "LOG IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,)
            ],
          ),
        ]),
      ),
    );
  }
}
