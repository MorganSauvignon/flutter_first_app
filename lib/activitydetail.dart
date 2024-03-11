import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityDetailPage extends StatefulWidget {
  final Map<String, dynamic> activity;

  ActivityDetailPage({required this.activity});

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late bool _addedToCart;

  @override
  void initState() {
    super.initState();
    _addedToCart = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity['title']),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  '${widget.activity['image']}?x-oss-process=image/resize,w_600', // Redimensionne l'image pour qu'elle prenne en longueur
                  width: double.infinity, // Prend toute la largeur disponible
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Titre: ${widget.activity['title']}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Catégorie: ${widget.activity['category']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Lieu: ${widget.activity['place']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Nombre de personnes minimum: ${widget.activity['minPeople']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Prix: ${widget.activity['price']}€',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _addedToCart = true;
                    });
                    Timer(Duration(milliseconds: 200), () {
                      setState(() {
                        _addedToCart = false;
                      });
                    });
                    // Ajouter l'activité dans le panier
                    addToCart(widget.activity);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _addedToCart ? Colors.green : null,
                  ),
                  child: Icon(
                    _addedToCart ? Icons.check : Icons.add_shopping_cart,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> addToCart(Map<String, dynamic> activity) async {
  print(FirebaseAuth.instance.currentUser);
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
