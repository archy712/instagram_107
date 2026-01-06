import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '/common/util/logger.dart';
import '/feed/enum/feed_type_enum.dart';

class FeedRepository {
  // FirebaseAuth
  final FirebaseAuth firebaseAuth;
  // FirebaseFirestore
  final FirebaseFirestore firebaseFirestore;
  // FirebaseStorage
  final FirebaseStorage firebaseStorage;

  // constructor
  const FeedRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  // 피드 업로드
  Future<void> uploadFeed({
    // 업로드 할 이미지 경로 리스트
    required List<String> feedMedias,
    // 피드 내용
    required String feedContent,
    // 피드 타입
    required FeedTypeEnum feedTypeEnum,
  }) async {
    try {
      // 문서ID 유일키 값 생성
      final String feedId = Uuid().v1();
      // 사용자 uid
      final String uid = firebaseAuth.currentUser!.uid;
      // Firestore [feeds] 컬렉션에 대한 DocumentReference
      final DocumentReference<Map<String, dynamic>> feedDocRef =
          firebaseFirestore.collection('feeds').doc(feedId);
      // FirebaseStorage Reference
      Reference storageRef = firebaseStorage.ref().child('feeds').child(feedId);
      // 이미지를 파일 경로 리스트를 순회하면서 FirebaseStorage 저장 + List<경로> 얻기
      // 리턴받을 형식은 List<String>, 리턴값은 List<Future<String>>
      // List<Future<String>> 에서 Future 를 없애려면 모든 작업이 다 끝날때 까지 기다림
      // -> 불일치 해소 위해 await Future.wait(—);
      final List<String> mediaUrls = await Future.wait(
        feedMedias.map((feedImage) async {
          // 파일 이름
          final String imageId = Uuid().v1();
          // 파일 저장 + 다운로드 경로 반환 (TaskSnapshot 사용)
          TaskSnapshot taskSnapshot = await storageRef
              .child(imageId)
              .putFile(File(feedImage));
          // Firestore 저장 위해 DownloadUrl 필요
          return await taskSnapshot.ref.getDownloadURL();
        }).toList(),
      );
      // [임시] 이미지 경로 출력
      logger.d(mediaUrls);
    } catch (_) {
      rethrow;
    }
  }
}
