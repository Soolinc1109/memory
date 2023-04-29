import 'package:cloud_firestore/cloud_firestore.dart';

class CarteFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference cartes =
      _firestoreInstance.collection('carte');
}
