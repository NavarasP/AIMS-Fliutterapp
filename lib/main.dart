import 'package:aims/screens/authentication/signin.dart';
import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home/homescreens/adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.containsKey('isLoggedIn') ? prefs.getBool('isLoggedIn')! : false;
  bool isAdmin = prefs.containsKey('isAdmin') ? prefs.getBool('isAdmin')! : false;
  // ignore: prefer_const_constructors
  FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyB9albtqvW6GWqUCP0wKC58D1wPDhnC6xg",
    appId: "1:882041925432:android:a1be78c1eac4ce530c5bcd",
    messagingSenderId: "882041925432",
    projectId: "imss-89998",
  );

  await Firebase.initializeApp(options: options);
  // ignore: avoid_print
  print("connected to Firebase");
  runApp(MyApp(isLoggedIn: isLoggedIn,isAdmin: isAdmin,));
}


class MyApp extends StatelessWidget {
 

  const MyApp({Key? key, required this.isLoggedIn, required this.isAdmin}) : super(key: key);

  final bool isLoggedIn;
  final bool isAdmin;
      final _isLoading = false;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (!isLoggedIn) {
      return const MaterialApp(
        home: SignInScreen(),
      );
    }

    final homeScreen = isAdmin ? const adminHomeScreen() : const HomeScreen();
    return MaterialApp(
      title: 'AIMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeScreen,
    );
  }
}
