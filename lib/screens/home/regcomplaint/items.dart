import 'package:aims/screens/home/regcomplaint/comp_desc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class itemScreen extends StatefulWidget {
  final String category;
  final String subcategory;
  const itemScreen({Key? key,required this.category,required this.subcategory}) : super(key: key);

  @override
  State<itemScreen> createState() => _itemScreenState();
}

class _itemScreenState extends State<itemScreen> {
get category => widget.category;
get subcategory => widget.subcategory;
final List<String> _items = [];
  bool _isLoading = true;

  Future<void> getItems() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('items').doc(category)
        .collection('Rooms').doc(subcategory)
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
        itemCount: _items.length, // Replace with the actual number of items
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
  );
}
}