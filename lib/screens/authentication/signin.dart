import 'package:aims/models/functions.dart';
import 'package:aims/screens/authentication/signup.dart';
import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:aims/screens/home/homescreens/adminhome.dart';
import 'package:aims/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

Future<void> _login() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    

    final email = _emailTextController.text;
    final password = _passwordTextController.text;
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);
            prefs.setBool('isLoggedIn', true);
    print("Logged In");
    navigateToHomeScreen(context);
  } on FirebaseAuthException catch (e) {
    String errorMessage = '';
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided for that user.';
    } else {
      errorMessage = 'An error occurred while logging in.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  }
}











  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous page
        SystemNavigator.pop();

        // Prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo.png"),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Amal Infrastructure Management System",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Username", Icons.person_outline, false,
                      _emailTextController),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      _passwordTextController),
                  SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton(context, true, _login),
                  // signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget signUpOption() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const Text("Don't have account?", style: TextStyle(color: Colors.white70)),
  //       GestureDetector(
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  //         },
  //         child: const Text(
  //           "Sign Up",
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
