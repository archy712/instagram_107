import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/auth/model/user_model.dart';

class UserRepository {
  // FirebaseAuth
  final FirebaseAuth firebaseAuth;

  // Firestore
  final FirebaseFirestore firebaseFirestore;

  // constructor
  const UserRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  // 현재 접속한 사용자의 모델 구하기
  Future<UserModel> getCurrentUser() async {
    try {
      // 현재 접속한 사용자의 uid
      final String uid = firebaseAuth.currentUser!.uid;

      // [users] 컬렉션에 대한 DocumentSnapshot 구하고
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firebaseFirestore.collection('users').doc(uid).get();

      // DocumentSnapshot 이용해서 UserModel 얻기
      UserModel currentUserModel = UserModel.fromMap(userSnapshot.data()!);

      return currentUserModel;
    } catch (_) {
      rethrow;
    }
  }
}
