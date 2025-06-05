
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getPeople() async {
    List<Map<String, dynamic>> people = [];
    CollectionReference collectionReferencePeople = db.collection('people');

    QuerySnapshot queryPeople = await collectionReferencePeople.get();

    for (var documento in queryPeople.docs) {
      people.add(documento.data() as Map<String, dynamic>);
    }

    return people;
}

Future<void> addPeople(String name) async {
    await db.collection('people').add({'name': name});
}

