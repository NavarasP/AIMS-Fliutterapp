// import necessary packages and files
import 'package:aims/screens/home/regcomplaint/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// create a StatefulWidget for the CategoriesScreen
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// create a State class for the CategoriesScreen
class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> _categories = [];

   
  bool _isLoading = true;

  Future<void> getCategories() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('items').get();
      snapshot.docs.forEach((doc) {
        _categories.add(doc.id);
      });
      print("Categories retrieved: $_categories");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error retrieving categories: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    getCategories();

  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Categories'),
    ),
    body: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => subCategoryScreen(
                          category: _categories[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
  );
}


}



