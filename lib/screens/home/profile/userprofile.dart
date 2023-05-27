import 'package:aims/screens/authentication/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aims/models/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData? userData;
  bool _isLoading = true;
  int _newComplaints = 0;
  int _processingComplaints = 0;
  int _completedComplaints = 0;
  
  

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userRef.get();
    final compRef =FirebaseFirestore.instance.collection('complaints');
    final compSnapshot  = await compRef.where('userId', isEqualTo: userId).get();
    final complaints = compSnapshot.docs;


    for (final complaint in complaints) {
      final status = complaint.data()['Status'];
      if (status == 'New') {
        _newComplaints++;
      } else if (status == 'Processing') {
        _processingComplaints++;
      } else if (status == 'Completed') {
        _completedComplaints++;
      }
    }

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
          : Column(
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('All'),
                          Text('${_newComplaints + _processingComplaints + _completedComplaints}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('New'),
                          Text('$_newComplaints'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Progress'),
                          Text('$_processingComplaints'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Completed'),
                          Text('$_completedComplaints'),
                        ],
                      ),
                    ),
                  ],
                ),
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
            ),
    );
  }
}
