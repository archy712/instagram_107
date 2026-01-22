import 'package:cloud_firestore/cloud_firestore.dart';

import '/auth/model/user_model.dart';

class ProfileRepository {
  // FirebaseFirestore
  final FirebaseFirestore firebaseFirestore;
  // constructor
  const ProfileRepository({required this.firebaseFirestore});

  // 프로필 사용자 정보 조회
  Future<UserModel> getUserModel({required String uid}) async {
    try {
      // 방법 1> DocumentReference > DocumentSnapshot > Map Data > Model
      //
      // // 1-1> DocumentReference
      // DocumentReference<Map<String, dynamic>> userDocRef = firebaseFirestore
      //     .collection('users')
      //     .doc(uid);
      //
      // // 1-2> DocumentSnapshot
      // DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userDocRef.get();
      //
      // // 1-3> Map Data
      // Map<String, dynamic> userMapData = userSnapshot.data()!;
      //
      // // 1-4> Model
      // UserModel userModel = UserModel.fromMap(userMapData);
      // 방법 2> Map Data 한번에 얻는 방법
      Map<String, dynamic> userMapData = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.data()!);
      return UserModel.fromMap(userMapData);
    } catch (_) {
      rethrow;
    }
  }
}
