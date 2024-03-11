import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController loginController = TextEditingController();
  late TextEditingController birthdayController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController postcodeController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> data = snapshot.data()!;
      setState(() {
        loginController = TextEditingController(text: user.email);
        birthdayController = TextEditingController(text: data['birthday'] ?? '');
        addressController = TextEditingController(text: data['address'] ?? '');
        postcodeController = TextEditingController(text: data['postcode'] ?? '');
        cityController = TextEditingController(text: data['city'] ?? '');
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

 Future<void> updateUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Vérifier si le champ de mot de passe est vide ou s'il est égal au champ de confirmation
        if (passwordController.text.isEmpty || passwordController.text == confirmPasswordController.text) {
          // Si le champ de mot de passe est rempli et égal au champ de confirmation, mettre à jour le mot de passe
          if (passwordController.text.isNotEmpty) {
            await user.updatePassword(passwordController.text);
          }
          // Mettre à jour les autres informations utilisateur
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'birthday': birthdayController.text,
            'address': addressController.text,
            'postcode': postcodeController.text,
            'city': cityController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Informations mises à jour')),
          );
          // Effacer les champs de mot de passe
          passwordController.clear();
          confirmPasswordController.clear();
        } else {
          // Si les mots de passe ne correspondent pas, afficher un message d'erreur
          setState(() {
            errorMessage = 'Les mots de passe ne correspondent pas.';
          });
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour des informations: $error')),
        );
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day, // Définit le mode du sélecteur de date sur jour seulement
    );
    if (picked != null) {
      setState(() {
        birthdayController.text = DateFormat('dd-MM-yyyy').format(picked); // Formater la date avant de l'afficher
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: loginController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Login'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.cake),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: birthdayController,
                          decoration: InputDecoration(
                            labelText: 'Anniversaire',
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Adresse'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: postcodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                      decoration: InputDecoration(labelText: 'Code postal'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'Ville'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await updateUserInfo();
                    },
                    child: Text('Valider'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signOut();
                    },
                    child: Text('Se déconnecter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
