import 'package:aims/screens/home/complaint/complaints.dart';
import 'package:aims/screens/home/profile/userprofile.dart';
import 'package:aims/screens/home/regcomplaint/categories.dart';
import 'package:aims/screens/home/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


Future<bool> _onWillPop() async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}





  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _children = [
    const CategoriesScreen(),
    const ComplaintsScreen(),
    const ProfileScreen(),
    
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Center(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _children,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Complaints',
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.stacked_bar_chart),
            label: 'Your Complaints',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}