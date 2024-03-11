import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_first_app/bottomBar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

Future<void> signIn(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DynamicBottomNavigation()),
    );
  } catch (e) {
    print('Erreur de connexion : $e');
    // Afficher une boîte de dialogue d'erreur
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur de connexion'),
          content: Text('Une erreur est survenue lors de la connexion : Veuillez vérifier votre adresse e-mail et votre mot de passe ou vous inscrire.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  Future<void> signUp(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      
      // Ajouter les autres informations utilisateur dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'birthday': '' ,
        'address': '',
        'postcode': '',
        'city': '',
      });
      
    } catch (e) {
      print('Erreur d\'inscription : $e');
      // Afficher une boîte de dialogue d'erreur
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur d\'inscription'),
            content: Text('Une erreur est survenue lors de l\'inscription : Veuillez rentrer une adresse mail valide et un mot de passe de 6 caractères minimum.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onSubmitted: (_) => signIn(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signIn(context),
              child: Text('Se connecter'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => signUp(context),
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
