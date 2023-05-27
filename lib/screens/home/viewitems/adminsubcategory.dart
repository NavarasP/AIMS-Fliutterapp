
import 'package:aims/screens/home/regcomplaint/items.dart';
import 'package:aims/screens/home/viewitems/adminitems.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminsubCategoryScreen extends StatefulWidget {
  final String category;
  const AdminsubCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<AdminsubCategoryScreen> createState() => _AdminsubCategoryScreenState();
}

class _AdminsubCategoryScreenState extends State<AdminsubCategoryScreen> {
get category => widget.category;
final List<String> _subcategories = [];
  bool _isLoading = true;

  Future<void> getSubCategories() async {
    try {
      _subcategories.clear(); 
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
              itemCount: _subcategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminitemScreen(
                          category: category,
                          subcategory: _subcategories[index],
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
                              'Are you sure you want to delete the category "${_subcategories[index]}"?',
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
                                        .doc(category)
                                        .collection('Rooms')
                                        .doc(_subcategories[index])
                                        .delete();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await getSubCategories();
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
floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String subcategoryName = '';
            return AlertDialog(
              title: Text('Add Category'),
              content: TextField(
                onChanged: (value) {
                  subcategoryName = value;
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
                  onPressed: () async{
                    if (subcategoryName.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('items')
                        .doc(category)
                        .collection('Rooms')
                        .doc(subcategoryName)
                        .set({});
                      Navigator.of(context).pop();
                       setState(() {
                _isLoading = true;
              });
              await getSubCategories();
            
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