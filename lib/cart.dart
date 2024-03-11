import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  final String userId;

  CartPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Le panier est vide'),
            );
          }

          // Calcul du prix total du panier
          double totalPrice = 0;
          snapshot.data!.docs.forEach((document) {
            var activityData = document.data() as Map<String, dynamic>;
            if (activityData['price'] is num) {
              totalPrice += activityData['price']; // Ajouter le prix au total
            }
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var activityData =
                        snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.network(activityData['image']),
                        title: Text(activityData['title']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(activityData['place']),
                            Text(
                              '${activityData['price']}€',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeFromCart(snapshot.data!.docs[index].id);
                          },
                        ),
                        onTap: () {
                          // Navigation vers la page de détails si nécessaire
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: ${totalPrice.toStringAsFixed(2)} \€',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _clearCart();
                      },
                      child: Text('Vider le panier'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeFromCart(String activityId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(activityId)
          .delete();
      print('Activité supprimée du panier avec succès');
    } catch (e) {
      print('Erreur lors de la suppression de l\'activité du panier: $e');
    }
  }

  Future<void> _clearCart() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      print('Panier vidé avec succès');
    } catch (e) {
      print('Erreur lors de la suppression du panier: $e');
    }
  }
}
