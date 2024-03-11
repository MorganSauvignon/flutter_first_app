import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'activities.dart'; // Remplacez activities_page.dart par le nom de votre fichier d'activités
import 'cart.dart'; // Remplacez cart_page.dart par le nom de votre fichier de panier
import 'profile.dart'; // Remplacez profile_page.dart par le nom de votre fichier de profil

class DynamicBottomNavigation extends StatefulWidget {

  const DynamicBottomNavigation({Key? key}) : super(key: key);

  @override
  _DynamicBottomNavigationState createState() => _DynamicBottomNavigationState();
}

class _DynamicBottomNavigationState extends State<DynamicBottomNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ActivitiesPage(),
    CartPage(userId: FirebaseAuth.instance.currentUser!.uid),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_volleyball),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
