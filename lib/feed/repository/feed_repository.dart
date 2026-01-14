import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '/auth/model/user_model.dart';
import '/common/util/logger.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/model/feed_model.dart';

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
  Future<FeedModel> uploadFeed({
    // 업로드 할 이미지 경로 리스트
    required List<String> feedMedias,
    // 피드 내용
    required String feedContent,
    // 피드 타입
    required FeedTypeEnum feedTypeEnum,
  }) async {
    // 트랜잭션 처리를 위해 try 문 밖에 선언
    // 피드 업로드 실패 시 업로드 된 미디어 삭제 위함
    List<String> mediaUrls = [];

    try {
      // 딜레이를 주고 싶을 때 (옵션)
      await Future.delayed(Duration(seconds: 5));
      // 트랜잭션 사용 위해 WriteBatch 변수 선언
      WriteBatch writeBatch = firebaseFirestore.batch();
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
      mediaUrls = await Future.wait(
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

      // 현재 유저의 정보에 접근할 수 있는 DocumentReference 얻기
      final DocumentReference<Map<String, dynamic>> userDocRef =
          firebaseFirestore.collection('users').doc(uid);

      // User : DocumentReference 로부터 DocumentSnapshot 얻기
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userDocRef
          .get();

      // UserModel : DocumentSnapshot 이용하여 UserModel 생성
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      // FeedModel 생성
      FeedModel feedModel = FeedModel(
        feedId: feedId,
        uid: uid,
        feedContent: feedContent,
        mediaUrls: mediaUrls,
        feedTypeEnum: feedTypeEnum,
        likes: [],
        commentCount: 0,
        likeCount: 0,
        bookmarks: [],
        sendCount: 0,
        createdAt: Timestamp.now(),
        writer: userModel,
      );

      // 여기서 강제로 Exception 발생시켜서 Transaction 테스트
      // throw Exception('파일 업로드 롤백 테스트');

      // FeedModel 이용하여 feeds 컬렉션 저장
      // await feedDocRef.set(feedModel.toMap(userDocRef: userDocRef));
      writeBatch.set(feedDocRef, feedModel.toMap(userDocRef: userDocRef));

      // Firestore : [users] 컬렉션의 feedCount 1 증가
      // await userDocRef.update({'feedCount': FieldValue.increment(1)});
      writeBatch.update(userDocRef, {'feedCount': FieldValue.increment(1)});

      // commit 전에 오류 테스트
      // throw Exception('트랜잭션 오류 테스트');

      // 최종 WriteBatch Commit 처리
      writeBatch.commit();

      // 새롭게 등록된 피드를 리턴하여 Cubit 에서 상태 업데이트
      return feedModel;
    } catch (_) {
      // 오류 발생 시 이미지가 업로드 되었다면, 해당 이미지 삭제
      await _deleteMedias(mediaUrls);

      rethrow;
    }
  }

  // 이미지 삭제 로직을 함수로 구현
  Future<void> _deleteMedias(List<String> mediaUrls) async {
    for (String mediaUrl in mediaUrls) {
      await firebaseStorage.refFromURL(mediaUrl).delete();
    }
  }

  // 최신 피드 목록 가져오기
  Future<List<FeedModel>> getRecentlyFeedList({required int count}) async {
    try {
      // feeds 컬렉션 데이터를 제한된 숫자 만큼 날짜 순으로 가져오기
      QuerySnapshot<Map<String, dynamic>> feedsSnapshot =
          await firebaseFirestore
              .collection('feeds')
              .orderBy('createdAt', descending: true)
              .limit(count)
              .get();
      // writer 값을 가져오기 위한 처리 + List<FeedModel> 반환
      return await Future.wait(
        feedsSnapshot.docs.map((doc) async {
          // 1개의 문서를 fetch
          Map<String, dynamic> feedData = doc.data();
          // 작성자의 Reference 구해서 get() 함수로 snapshot 구함
          DocumentReference<Map<String, dynamic>> writerDocRef =
              feedData['writer'];
          DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
              await writerDocRef.get();
          // 피드를 작성한 유저의 정보를 UserModel
          UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
          feedData['writer'] = userModel;
          // 1개의 피드를 반환
          return FeedModel.fromMap(feedData);
        }),
      );
    } catch (_) {
      rethrow;
    }
  }

  // 피드 목록 가져오기
  Future<List<FeedModel>> getFeedList() async {
    try {
      // feeds 컬렉션 데이터를 날짜 순으로 가져오기
      QuerySnapshot<Map<String, dynamic>> feedsSnapshot =
          await firebaseFirestore
              .collection('feeds')
              .orderBy('createdAt', descending: true)
              .get();
      // writer 값을 가져오기 위한 처리 + List<FeedModel> 반환
      return await Future.wait(
        feedsSnapshot.docs.map((doc) async {
          // 1개의 문서를 fetch
          Map<String, dynamic> feedData = doc.data();
          // 작성자의 Reference 구해서 get() 함수로 snapshot 구함
          DocumentReference<Map<String, dynamic>> writerDocRef =
              feedData['writer'];
          DocumentSnapshot<Map<String, dynamic>> writerSnapshot =
              await writerDocRef.get();
          // 피드를 작성한 유저의 정보를 UserModel
          UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
          feedData['writer'] = userModel;
          // 1개의 피드를 반환
          return FeedModel.fromMap(feedData);
        }),
      );
    } catch (_) {
      rethrow;
    }
  }
}
