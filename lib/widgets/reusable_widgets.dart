import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,

    width: 170,
    height: 210,
    // color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container checkField(
  String label,
  String hint,
  IconData icon,
  TextEditingController controller,
  Function()? onPressed,
) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            'Button',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    ),
  );
}

// Container checkField(
//     String text,String hint,IconData icon, TextEditingController controller) {
//   return Container(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
//       children: [
//         const Text(
//           'Enter Code ',
//           textAlign: TextAlign.left, // Align label text to the left
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   hintText: 'AABBCC01',
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Perform action on button press
//               },
//               child: const Text('Button'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      // ignore: sort_child_properties_last
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Container dropDown(
  BuildContext context,
  String name,
  List<String> items,
  String? selectedItem,
  Function(String?)? onDropdownChanged,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DropdownButton(
          dropdownColor: Colors.white,
          elevation: 5,
          icon: Icon(Icons.arrow_drop_down),
          isExpanded: true,
          underline: SizedBox(),
          hint: Padding(
            padding: const EdgeInsets.only(left: 8.0), // Add this line
            child: Text(
              name,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
          value: selectedItem, // Pass in the selected item
          onChanged: onDropdownChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Container(
                // margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                // decoration: BoxDecoration(
                //   color: Colors
                //       .grey.shade100, // Set the desired background color here
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    ),
  );
}

// Container dropDown(
//   BuildContext context,
//   String name,
//   List<String> items,
//   String? selectedItem,
//   Function(String?)? onDropdownChanged,
// ) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: 50,
//     margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(90),
//       border: Border.all(color: Colors.grey), // Add border for clarity
//     ),
//     child: StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return DropdownButton(
//           hint: Text(name), // Display the name as hint text
//           value: selectedItem, // Pass in the selected item
//           onChanged: onDropdownChanged,
//           items: items.map((item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Text(item),
//             );
//           }).toList(),
//         );
//       },
//     ),
//   );
// }

// AlertDialog Alert(BuildContext context, String alert) {
//   return AlertDialog(
//     // title: const Text("Login Error"),
//     content: Text(alert),
//     actions: [
//       TextButton(
//         onPressed: () => Navigator.pop(context),
//         child: const Text("OK"),
//       ),
//     ],
//   );
// }


// class CustomAlertDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final String buttonText;
//   final Function() onPressed;

//   const CustomAlertDialog({
//     Key? key,
//     required this.title,
//     required this.message,
//     required this.buttonText,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(message),
//       actions: [
//         TextButton(
//           onPressed: onPressed,
//           child: Text(buttonText),
//         ),
//       ],
//     );
//   }
// }