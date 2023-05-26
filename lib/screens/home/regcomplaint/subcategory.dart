import 'package:aims/screens/home/homescreens/homescrren.dart';
import 'package:aims/screens/home/regcomplaint/items.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class subCategoryScreen extends StatefulWidget {
  final String category;
  const subCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<subCategoryScreen> createState() => _subCategoryScreenState();
}

class _subCategoryScreenState extends State<subCategoryScreen> {
get category => widget.category;
final List<String> _subcategories = [];
  bool _isLoading = true;

  Future<void> getSubCategories() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('items').doc(category)
        .collection('Rooms')
        .get();
      snapshot.docs.forEach((doc) {
        _subcategories.add(doc.id);
      });
      print("Categories retrieved: $_subcategories");
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
    getSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
      ),
      body:  _isLoading
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
        itemCount: _subcategories.length, // Replace with the actual number of items
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
                  // title: Text(_subcategories[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => itemScreen(
                          category: category,
                          subcategory: _subcategories[index],
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
                          _subcategories[index],
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



