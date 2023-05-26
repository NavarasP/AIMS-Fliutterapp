// Container dropDown(BuildContext context, String name) {
//   List<String> items = ['Item 1', 'Item 2', 'Item 3']; // Example list of items
//   String? selectedItem;

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
//           value: selectedItem as String?, // Pass in the selected item
//           onChanged: (value) {
//             setState(() {
//               selectedItem = value as String; // Update the selected item
//             });
//           },
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





// import 'package:aims/screens/authentication/signin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(
//                       'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'John Doe',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'john.doe@example.com',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               color: Colors.grey[200],
//               child: Center(
//                 child: Text('This is the profile page.'),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed:  () async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setBool('isLoggedIn', false);
//             FirebaseAuth.instance.signOut().then((value) {
//               // ignore: avoid_print
//               print("Signed out");
//                 Navigator.push(context, 
//               MaterialPageRoute(builder: (context)=> const SignInScreen()));
//             });
//             },
//             child: Text('Logout'),
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }







// signin

// import 'package:aims/screens/authentication/signup.dart';
// import 'package:aims/screens/home/homescrren.dart';
// import 'package:aims/widgets/reusable_widgets.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   TextEditingController _passwordTextController = TextEditingController();
//   TextEditingController _emailTextController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigate back to the previous page
//         SystemNavigator.pop();
        
//         // Prevent the default back button behavior
//         return false;
//       },
    
//     child: Scaffold(
//       backgroundColor: Colors.white70,
//       body: Container(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//                 20, MediaQuery.of(context).size.height * 0.2, 20, 0),
//             child: Column(
//               children: <Widget>[
//                 logoWidget("assets/images/logo.png"),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 const Text("Amal Infrastructure Management System",
//                  style: TextStyle(color: Colors.white70),
//                  ),
//                  SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Username", Icons.person_outline, false,
//                     _emailTextController),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 reusableTextField("Enter Password", Icons.lock_outline, true,
//                     _passwordTextController),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 signInSignUpButton(context, true, () async {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setBool('isLoggedIn', true);
//                   FirebaseAuth.instance
//                       .signInWithEmailAndPassword(
//                           email: _emailTextController.text,
//                           password: _passwordTextController.text)
//                       .then((value) {
//                     print("Logged In");
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => HomeScreen()));
//                   }).onError((error, stackTrace) {
//                     print("Error ${error.toString()}");
//                   });
//                 }),
//                 signUpOption()
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//   }

//   Row signUpOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have account?",
//             style: TextStyle(color: Colors.white70)),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => SignUpScreen()));
//           },
//           child: const Text(
//             "Sign Up",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         )
//       ],
//     );
    
//   }
// }



















// SIGNUP

// import 'package:aims/screens/authentication/signup.dart';
// import 'package:aims/screens/home/homescrren.dart';
// import 'package:aims/widgets/reusable_widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController _userNameTextController=TextEditingController();
//   TextEditingController _passwordTextController=TextEditingController();
//   TextEditingController _emailTextController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white70,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors. transparent,
//         elevation: 0,
//         title: const Text(
//           "Sign Up",
//           style: TextStyle( fontSize:24, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Padding(
//               padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
//               child: Column(
//           children: <Widget>[
//             reusableTextField("Enter Username", Icons.person_outline, false, 
//             _userNameTextController),
//             SizedBox(
//               height: 20,
//             ),
//             reusableTextField("Enter Email Id", Icons.person_outline, false, 
//             _emailTextController),
//             SizedBox(
//               height: 20,
//             ),
//             reusableTextField("Enter Password", Icons.lock_outline, true,
//             _passwordTextController),
//             SizedBox(
//               height: 20,
//             ),
//             signInSignUpButton( context, false,(){
//               FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text, 
//               password: _passwordTextController.text).then((value){
//                 print("Created New Account");
//                    Navigator.push(context,
//                   MaterialPageRoute(builder: (context)=> HomeScreen()));
//               }).onError((error, stackTrace) {
//                 print("Error ${error.toString()}");
//               });


             
//             })
//           ],
//               ),
//                 ))),
//     );
//   }
// }


// import 'package:aims/widgets/reusable_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {

//  String? selectedItem; // define selectedItem variable here

//   void setSelectedItem(String? value) { // define setter method for selectedItem
//     setState(() {
//       selectedItem = value;
//     });
//   }


//   TextEditingController _itemCodeController = TextEditingController();




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("register screen"),
//         automaticallyImplyLeading: false,

//       ),

//       body: Column(
//         children: <Widget>[
//           checkField("text", "hint", Icons.abc, _itemCodeController),
//           dropDown(  context,  'Select an item1',  ['Item 1', 'Item 2', 'Item 3'],  selectedItem,  (value) {    selectedItem = value; },),
//           dropDown(  context,  'Select an item2',  ['Item 4', 'Item 11', 'Item 12'],  selectedItem,  (value) {    selectedItem = value; },),
//           dropDown(  context,  'Select an item3',  ['Item 5', 'Item 10', 'Item 13'],  selectedItem,  (value) {    selectedItem = value; },),
//           dropDown(  context,  'Select an item4',  ['Item 6', 'Item 9', 'Item 14'],  selectedItem,  (value) {    selectedItem = value; },),
//           dropDown(  context,  'Select an item5',  ['Item 7', 'Item 8', 'Item 15'],  selectedItem,  (value) {    selectedItem = value; },),


//         ],)

        
        
//       );

    

    
//   }
// }









///////////////////////////////////////////////////////////////////


// class _ComplaintsScreenState extends State<ComplaintsScreen> {
//   List<QueryDocumentSnapshot> _newComplaints = [];
//   List<QueryDocumentSnapshot> _processingComplaints = [];
//   List<QueryDocumentSnapshot> _completedComplaints = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
    
//     {getComplaintData();}
//   }

//   Future<void> getComplaintData() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     final userRef = FirebaseFirestore.instance.collection('users/$userId/complaints');
//     final userSnapshot = await userRef.get();
//     final complaints = userSnapshot.docs;

//     for (final complaint in complaints) {
//       final status = complaint.data()['status'];
//       if (status == 'New') {
//         _newComplaints.add(complaint);
//       } else if (status == 'Processing') {
//         _processingComplaints.add(complaint);
//       } else if (status == 'Completed') {
//         _completedComplaints.add(complaint);
//       }
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complaints'),
//         automaticallyImplyLeading: false,
//       ),
//       body: _isLoading
          //  ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (_newComplaints.isNotEmpty)
//                     _buildCategoryList('New', _newComplaints),
//                   if (_processingComplaints.isNotEmpty)
//                     _buildCategoryList('Processing', _processingComplaints),
//                   if (_completedComplaints.isNotEmpty)
//                     _buildCategoryList('Completed', _completedComplaints),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildCategoryList(String title, List<QueryDocumentSnapshot> complaints) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: complaints.length,
//           itemBuilder: (context, index) {
//             final doc = complaints[index];
//                  final data = doc.data() as Map<String, dynamic>;
//             return Card(
//               child: ListTile(
//                 title: Text(data['Title'] ?? 'Unknown'),
//                      subtitle: Text('Product ID: ${data['Product ID'] ?? 'Unknown'}\n'
//                          'Description: ${data['Description'] ?? 'Unknown'}\n'
//                          'Date: ${data['timestamp'] ?? 'Unknown'}\n'
//                          'Status: ${data['Status'] ?? 'Unknown'}'),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

/////////////////////////////////////////////////////////////////