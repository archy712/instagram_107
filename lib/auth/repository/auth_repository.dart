import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  // FirebaseAuth
  final FirebaseAuth firebaseAuth;
  // FirebaseFirestore
  final FirebaseFirestore firebaseFirestore;
  // FirebaseStorage
  final FirebaseStorage firebaseStorage;

  // constructor
  const AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });
}
