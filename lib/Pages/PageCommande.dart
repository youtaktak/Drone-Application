import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class PageCommande extends StatefulWidget {
  const PageCommande({super.key});

  @override
  State<PageCommande> createState() => _PageCommandeState();
}

class _PageCommandeState extends State<PageCommande> {

  final _formkey=GlobalKey<FormState>();
  final ArticleController = TextEditingController();
  String? TypeLivraison = null;
  DateTime? selectedDate;

  void dispose(){
    ArticleController.dispose();
    super.dispose();
  }
  void onChanged(String? value) {
    setState(() {
      TypeLivraison = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passer une commande"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Article à livrer*',
                        hintText: "faire entrer l'article à livrer",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if (value==null||value.isEmpty){
                          return "champ obligatoire*";
                        }
                        return null;
                      },
                      controller: ArticleController,

                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child:
                    DropdownButtonFormField <String>(
                      value: TypeLivraison,
                      decoration: const InputDecoration(
                        labelText: 'Type de livraison*',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: onChanged,
                      items: const[
                        DropdownMenuItem(
                          child: Text("Livraison en urgence!"),
                          value: "urgence",
                        ),
                        DropdownMenuItem(
                          child: Text("Livraison Normale"),
                          value: "Normale",

                        )

                      ],
                      validator: (value) {
                        if (value == null) {
                          return "Champ obligatoire*";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: DateTimeFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date de la Livraison',
                        border: OutlineInputBorder(),
                      ),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      initialPickerDateTime: DateTime.now().add(const Duration(days: 7)),
                      onChanged: (DateTime? value) {
                        selectedDate = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Envoi en cours...")),
                          );
                          CollectionReference colisref=FirebaseFirestore.instance.collection("Colis");
                          colisref.add({
                            'article':ArticleController.text,
                            'date':  selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
                            'type': TypeLivraison ,
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Commande enregistrée avec succès !")),
                            );
                            ArticleController.clear();
                            setState(() {
                              TypeLivraison = null;
                              selectedDate = null;
                            });
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erreur lors de l'enregistrement : $error")), );
                          });


                        }
                      },
                      child: const Text("Valider", style: TextStyle(fontSize: 18)),
                    ),
                  ),





                ],
              )
          ),
        ),
      ),
    );
  }
}


