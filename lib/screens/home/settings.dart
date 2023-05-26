import 'package:flutter/material.dart';

class settingsScreen extends StatefulWidget {
  const settingsScreen({Key? key}) : super(key: key);

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {
  String? selectedValue;

  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      hint: Text('Select an item'),
    );
  }
}