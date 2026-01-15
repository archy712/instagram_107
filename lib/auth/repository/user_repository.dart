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

  // follow / unfollow 처리
  Future<UserModel> followUser({
    required String currentUserUid,
    required String followUid,
  }) async {
    try {
      // 접속한 유저의 [users] 컬렉션에 대한 DocumentReference 얻기
      DocumentReference<Map<String, dynamic>> currentUserDocRef =
          firebaseFirestore.collection('users').doc(currentUserUid);
      // 상대방 유저의 [users] 컬렉션에 대한 DocumentReference 얻기
      DocumentReference<Map<String, dynamic>> followUserDocRef =
          firebaseFirestore.collection('users').doc(followUid);
      // 방법 1> Snapshot 얻고, 데이터 얻고 등 2단계로 처리
      // DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
      //     await currentUserDocRef.get();
      //
      // List<String> following = List<String>.from(
      //   currentUserSnapshot.data()!['following'],
      // );
      // 방법 2> then 키워드 사용하여 한번에 처리
      // then 키워드의 앞 작업이 끝날때까지 기다렸다가 then 키워드의 뒷작업 처리
      List<String> following = await currentUserDocRef.get().then(
        (value) => List<String>.from(value.data()!['following']),
      );
      // 트랜잭션을 위해 WriteBatch 방식 사용
      WriteBatch writeBatch = firebaseFirestore.batch();
      if (following.contains(followUid)) {
        // 이미 대상 uid를 follow 하고 있다면 => unfollow 처리 (배열에서 삭제)
        // 1> 현재 접속한 사용자의 데이터에서 상대방의 데이터 삭제 : following 필드
        writeBatch.update(currentUserDocRef, {
          'following': FieldValue.arrayRemove([followUid]),
        });
        // 2> 상대방 데이터에서도 현재 접속자의 데이터를 삭제 : followers 필드
        writeBatch.update(followUserDocRef, {
          'followers': FieldValue.arrayRemove([currentUserUid]),
        });
      } else {
        // 대상 uid를 follow 하고 있지 않다면 => following 처리 (배열에 추가)
        // 1> 현재 접속한 사용자의 데이터에서 상대방의 데이터 추가 : following 필드
        writeBatch.update(currentUserDocRef, {
          'following': FieldValue.arrayUnion([followUid]),
        });
        // 2> 상대방 데이터에서도 현재 접속자의 데이터를 추가 : followers 필드
        writeBatch.update(followUserDocRef, {
          'followers': FieldValue.arrayUnion([currentUserUid]),
        });
      }
      // 작업을 최종 commit
      writeBatch.commit();
      // 현재 접속한 유저의 UserModel 정보를 받아와서 반환
      Map<String, dynamic> currentUserMap = await currentUserDocRef.get().then(
        (value) => value.data()!,
      );
      return UserModel.fromMap(currentUserMap);
    } catch (_) {
      rethrow;
    }
  }
}
