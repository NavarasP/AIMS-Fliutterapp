import 'package:aims/models/functions.dart';
import 'package:aims/screens/home/complaint/admincomplaint.dart';
import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:aims/screens/home/profile/userprofile.dart';
import 'package:aims/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _itemCodeController = TextEditingController();

  late final Map<String, List<String>> _items ;
  String? _selectedCategories ;
  String? _selectedDepartment;
  String? _selectedYear;

  late String location;

  final List<String> _categories = [];




 
  
  

  Future<void> addComplaint(String location) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User not logged in');
    }

    CollectionReference complaintsCollection =
        FirebaseFirestore.instance.collection('users/$userId/complaints');

    try {
      await complaintsCollection.add({
        'Title': 'title',
        'timestamp': "FieldValue.serverTimestamp()",
        'Product ID': "Note Found",
        'Description': "complaint",
        'Status': "New",
        'Location': location,
      });
    } catch (e) {
      throw Exception('Error adding complaint: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }
  
Future<void> getCategories() async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('items')
        .get();
    snapshot.docs.forEach((doc) {
      _categories.add(doc.id);
    });
    print("Categories retrieved: $_categories");
  } catch (e) {
    print("Error retrieving categories: $e");
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       

        title: const Text("Register Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
              children: [
                dropDown(
                  context,
                  'Select Area',
                  _categories,
                  _selectedCategories,
                  (value) {
                    setState(() {
                      _selectedCategories = value;
                      _selectedDepartment = null;
                      _selectedYear = null;
                    });
                  },
                ),
                // if (_selectedCategories != null)
                //   dropDown(
                //     context,
                //     'Select Department',
                //     _department[_selectedArea]!,
                //     _selectedDepartment,
                //     (value) {
                //       setState(() {
                //         _selectedDepartment = value;
                //         _selectedYear = null;
                //       });
                //     },
                //   ),
                // if (_selectedDepartment != null)
                //   dropDown(
                //     context,
                //     'Select Year',
                //     _year[_selectedDepartment]!,
                //     _selectedYear,
                //     (value) {
                //       setState(() {
                //         _selectedYear = value;
                //       });
                //     },
                //   ),
                // dropDown(
                //   context,
                //   'Select an item4',
                //   ['Item 6', 'Item 8', 'Item 9'],
                //   selectedItem,
                //   (value) {
                //     setState(() {
                //       _selectedState = value;
                //     });
                //   },
                // ),

                const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                location = "$_selectedCategories/$_selectedDepartment/$_selectedYear";
                await addComplaint(location);
                navigateToHomeScreen(context);
              },
              child: const Text('Find'),
            ),
              ],
            ),
            
        
        ),
    
    );
  }
}
