import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore basedatos = FirebaseFirestore.instance;

Future<List> getpeople() async {
  List people = [];
  CollectionReference collectionReference = basedatos.collection('people');
  QuerySnapshot queryPeople = await collectionReference.get();

  queryPeople.docs.forEach((element) {
    people.add(element.data());
  });
  return people;
}