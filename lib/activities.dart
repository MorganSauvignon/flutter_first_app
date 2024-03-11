import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_first_app/activitydetail.dart';
import 'package:flutter_first_app/cart.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _categories = ['Toutes']; // Liste des catégories
  List<DocumentSnapshot> _activities = []; // Liste des activités
  late String _selectedCategory = 'Toutes'; // Catégorie sélectionnée par défaut

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchActivities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fonction pour récupérer les activités depuis Firestore
  Future<void> _fetchActivities() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('activities').get();
    setState(() {
      _activities = snapshot.docs;

      // Mettre à jour les catégories disponibles
      _updateCategories();
    });
  }

  // Fonction pour mettre à jour les catégories disponibles
  void _updateCategories() {
    Set<String> categories = {'Toutes'};
    _activities.forEach((activity) {
      categories.add(activity['category']);
    });
    setState(() {
      _categories = categories.toList();
      _tabController = TabController(length: _categories.length, vsync: this);
    });
  }

  // Fonction pour gérer la sélection d'une catégorie dans la TabBar
  void _handleTabSelection() {
    setState(() {
      _selectedCategory = _categories[_tabController.index];
    });
  }

  // Fonction pour filtrer les activités par catégorie
  List<DocumentSnapshot> _filterActivitiesByCategory(String category) {
    if (category == 'Toutes') {
      return _activities;
    } else {
      return _activities.where((activity) => activity['category'] == category).toList();
    }
  }

  // Fonction pour ajouter une activité dans le panier
  Future<void> _addToCart(Map<String, dynamic> activity) async {
    // Vérifiez si l'utilisateur est connecté
    if (FirebaseAuth.instance.currentUser != null) {
      // Récupérez l'ID de l'utilisateur actuellement connecté
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Ajoutez l'activité au panier de cet utilisateur dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('cart').add(activity);
    } else {
      // Gérez le cas où l'utilisateur n'est pas connecté
      print('Utilisateur non connecté');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des activités'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          List<DocumentSnapshot> filteredActivities = _filterActivitiesByCategory(category);
          return ListView.builder(
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              var activityData = filteredActivities[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailPage(activity: activityData)),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          activityData['image'],
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activityData['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              activityData['place'],
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${activityData['price']}€',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                AddToCartButton(
                                  onPressed: () {
                                    _addToCart(activityData);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final Function onPressed;

  AddToCartButton({required this.onPressed});

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool _addedToCart = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _addedToCart
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.add_shopping_cart),
      ),
      onPressed: () {
        setState(() {
          _addedToCart = true;
        });
        widget.onPressed();
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _addedToCart = false;
          });
        });
      },
    );
  }
}
