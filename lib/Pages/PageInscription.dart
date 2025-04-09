// pages/PageInscription.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Page_de_connexion.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  _PageInscriptionState createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Création du document utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
      });

      // Redirection vers la page de login après inscription
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = 'Erreur d\'inscription';
      if (e.code == 'weak-password') message = 'Mot de passe trop faible';
      if (e.code == 'email-already-in-use') message = 'Email déjà utilisé';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer un email'
                    : !value.contains('@')
                    ? 'Email invalide'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Minimum 6 caractères'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Confirmez votre mot de passe'
                    : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('S\'inscrire'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: const Text('Déjà un compte ? Connectez-vous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}