import 'package:aims/screens/home/regcomplaint/comp_desc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminitemScreen extends StatefulWidget {
  final String category;
  final String subcategory;
  const AdminitemScreen(
      {Key? key, required this.category, required this.subcategory})
      : super(key: key);

  @override
  State<AdminitemScreen> createState() => _AdminitemScreenState();
}

class _AdminitemScreenState extends State<AdminitemScreen> {
  get category => widget.category;
  get subcategory => widget.subcategory;
  final List<String> _items = [];
  bool _isLoading = true;

  Future<void> getItems() async {
    try {
      _items.clear();
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .doc(category)
          .collection('Rooms')
          .doc(subcategory)
          .collection('items')
          .get();
      snapshot.docs.forEach((doc) {
        _items.add(doc.id);
      });
      print("Categories retrieved: $_items");
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
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subcategory'),
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
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompDescrpScreen(
                            category: category,
                            subcategory: subcategory,
                            item: _items[index],
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
                              'Are you sure you want to delete the category "${_items[index]}"?',
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
                                        .doc(subcategory)
                                        .collection('items')
                                        .doc(_items[index])
                                        .delete();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await getItems();
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
                            _items[index],
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
              String itemType = '';
              String itemCode = '';
              return AlertDialog(
                title: Text('Add Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        itemType = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Item Type',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        itemCode = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Item code',
                      ),
                    ),
                  ],
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
                      if (itemType.isNotEmpty && itemCode.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('items')
                            .doc(category)
                            .collection('Rooms')
                            .doc(subcategory)
                            .collection('items')
                            .doc(itemCode)
                            .set({
                          'Code': itemCode,
                          'Location': '$category/$subcategory/$itemType',
                          'item_category': itemType,
                        });
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = true;
                        });
                        await getItems();
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
