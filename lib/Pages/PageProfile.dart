import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _nameController.text = doc['name'] ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = doc['phone'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  Widget _buildEditableField(String label, TextEditingController controller, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing && !isEmail,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => _isEditing ? _updateProfile() : setState(() => _isEditing = true),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.blueGrey),
            const SizedBox(height: 30),
            _buildEditableField('Nom complet', _nameController),
            const SizedBox(height: 20),
            _buildEditableField('Email', _emailController, isEmail: true),
            const SizedBox(height: 20),
            _buildEditableField('Téléphone', _phoneController),
            const SizedBox(height: 30),
            if (_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() => _isEditing = false);
                  _loadUserData();
                },
                child: const Text('Annuler les modifications'),
              ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () => _auth.signOut(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}