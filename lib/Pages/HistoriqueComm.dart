// pages/PageHistorique.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageHistorique extends StatelessWidget {
  const PageHistorique({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des Commandes')),
      body: user == null
          ? const Center(child: Text('Connectez-vous pour voir l\'historique'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              return ListTile(
                title: Text(order['adresse']),
                subtitle: Text('Statut: ${order['status']}'),
                trailing: Text(order['date'].toDate().toString().substring(0, 16)),
              );
            },
          );
        },
      ),
    );
  }
}