import 'package:aims/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home/homescreens/adminhome.dart';
import '../screens/home/homescreens/homescrren.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserData? userData;

Future<void> navigateToHomeScreen(BuildContext context) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final userSnapshot = await userRef.get();
  userData = UserData.fromFirestore(userSnapshot);
  final type = userData?.typeuser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
    
if (type== true) {
  prefs.setBool('isAdmin', false);
}
else if (type== false) {
  prefs.setBool('isAdmin', true);

}


  bool isAdmin = prefs.containsKey('isAdmin') ? prefs.getBool('isAdmin')! : false;




  final destination =isAdmin ? const adminHomeScreen() : const HomeScreen() ;
  
 Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
  
}

