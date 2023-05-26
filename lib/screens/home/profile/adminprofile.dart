import 'package:aims/screens/authentication/signin.dart';
import 'package:aims/screens/authentication/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aims/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminProfileScreen extends StatefulWidget {
  const adminProfileScreen({Key? key}) : super(key: key);

  @override
  State<adminProfileScreen> createState() => _adminProfileScreenState();
}

class _adminProfileScreenState extends State<adminProfileScreen> {
   UserData? userData;
  bool _isLoading = true;

  
  

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userRef.get();





    setState(() {
      userData = UserData.fromFirestore(userSnapshot);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 50,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) => Text(
                          userData?.name ?? '',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) => Text(
                          userData?.email ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
               
               
                ElevatedButton(
                  onPressed: () async {                  
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    
                  },
                  child: const Text('Add User'),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    FirebaseAuth.instance.signOut().then((value) {
                      // ignore: avoid_print
                      print("Signed out");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    });
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(height: 16),
              ],
            )),
    );
  }
}
