import 'package:aims/models/functions.dart';
import 'package:aims/screens/authentication/signup.dart';
import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:aims/widgets/reusable_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  bool _isSignUpError = false;
  bool? _isTypeUserAdmin; 
  String _signUpErrorMessage = '';

 Future<void> signUp() async {
    try {
      FirebaseApp newUserApp = await Firebase.initializeApp(
  name: "newUserApp",
  options: FirebaseOptions(
    apiKey: "AIzaSyB9albtqvW6GWqUCP0wKC58D1wPDhnC6xg",
    // authDomain: "your_auth_domain",
    projectId: "imss-89998",
    appId: "1:882041925432:android:a1be78c1eac4ce530c5bcd",
    messagingSenderId: "882041925432",
    // measurementId: "your_measurement_id",
  ),
);



      FirebaseAuth auth = FirebaseAuth.instanceFor(app: newUserApp);
       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      User? user = userCredential.user;
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      await usersRef.doc(user!.uid).set({
        'name': _userNameTextController.text,
        'email': _emailTextController.text,
        'typeuser': _isTypeUserAdmin,
      });

      print('User account created and data added successfully');
      

      // Navigate back to the admin account screen
      Navigator.pop(context);
    } catch (error) {
      setState(() {
      
        _isSignUpError = true;
        _signUpErrorMessage = 'Failed to create user account: ${error.toString()}';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                reusableTextField(
                    "Enter Username", Icons.person_outline, false, _userNameTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Email Id", Icons.person_outline, false, _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Password", Icons.lock_outline, true, _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: false,
                      groupValue: _isTypeUserAdmin,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTypeUserAdmin = value;
                        });
                      },
                    ),
                    const Text('Admin'),
                    Radio(
                      value: true,
                      groupValue: _isTypeUserAdmin,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTypeUserAdmin = value;
                        });
                      },
                    ),
                    const Text('User'),
                  ],
                ),
                signInSignUpButton(context, false, signUp),
                if (_isSignUpError)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _signUpErrorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
