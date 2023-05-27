import 'package:aims/models/functions.dart';
import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/data_model.dart';


class CompDescrpScreen extends StatefulWidget {
    final String category;
  final String subcategory;
  final String item;
  const CompDescrpScreen({Key? key,required this.category,required this.subcategory, required this.item}) : super(key: key);

  @override
  State<CompDescrpScreen> createState() => _CompDescrpScreenState();
}

class _CompDescrpScreenState extends State<CompDescrpScreen> {
ItemData?itemData;
get category => widget.category;
get subcategory => widget.subcategory;
get item => widget.item;

  // void navigateToHomeScreen() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) =>HomeScreen()),
  //   );
  // }



  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    // final userId = FirebaseAuth.instance.currentUser?.uid;
    final itemRef = FirebaseFirestore.instance.collection('items').doc(category)
        .collection('Rooms').doc(subcategory)
        .collection('items').doc(item);
    final itemSnapshot = await itemRef.get();
    setState(() {
      itemData = ItemData.fromFirestore(itemSnapshot);
    });
  }


Future<void> addComplaint() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    DateTime currentDate = DateTime.now();
int year = currentDate.year;
int month = currentDate.month;
int day = currentDate.day;
DateTime dateOnly = DateTime(year, month, day);


    if (userId == null) {
      throw Exception('User not logged in');
    }

    CollectionReference complaintsCollection =
        FirebaseFirestore.instance.collection('complaints');

    try {
      await complaintsCollection.add({
        'Item Code': itemData?.itemCode ??'',
        'userId':userId,
        'timestamp': FieldValue.serverTimestamp(),
        'Description': _textFieldValue,
        'Status': "New",
        'Location': itemData?.location??'',
      });
    } catch (e) {
      throw Exception('Error adding complaint: $e');
    }
  }




  final _formKey = GlobalKey<FormState>();
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Form Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _textFieldValue = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await addComplaint();
                    print('Text field value: $_textFieldValue');
                    navigateToHomeScreen(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
