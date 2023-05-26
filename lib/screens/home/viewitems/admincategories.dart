
import 'package:aims/screens/home/regcomplaint/subcategory.dart';
import 'package:aims/screens/home/viewitems/adminsubcategory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}


class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  final List<String> _categories = [];

  bool _isLoading = true;

  Future<void> getCategories() async {
    try {
      _categories.clear();
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
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                          builder: (context) => AdminsubCategoryScreen(
                            category: _categories[index],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete category?'),
                            content: Text(
                              'Are you sure you want to delete the category "${_categories[index]}"?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('items')
                                        .doc(_categories[index])
                                        .delete();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await getCategories();
                                  } catch (e) {
                                    print("Error deleting category: $e");
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
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
                            Icons.category,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String categoryName = '';
              return AlertDialog(
                title: Text('Add Category'),
                content: TextField(
                  onChanged: (value) {
                    categoryName = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter category name',
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      if (categoryName.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('items')
                            .doc(categoryName)
                            .set({});
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = true;
                        });
                        await getCategories();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
