import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '/auth/model/user_model.dart';
import '/common/util/logger.dart';

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

  // 이메일/비밀번호 기반 회원가입
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String name,
    required String comment,
    required String password,
    File? profileImage,
  }) async {
    try {
      // 넘어온 값 확인
      logger.i(
        'email: $email, name: $name, comment: $comment, password: $password, profileImage: ${profileImage?.path..toString()}',
      );
      // FirebaseAuth 회원정보 생성
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // 임시로 값 출력
      logger.d(userCredential.toString());

      // 인증 메일 전송
      await userCredential.user!.sendEmailVerification();

      // uid 조회 : Firestore의 Document ID, 프로필 이미지 저장 시 디렉토리 구분 위해
      String uid = userCredential.user!.uid;

      // 프로필 이미지 URL
      String? profileImageUrl;

      // 프로필 이미지 저장
      if (profileImage != null) {
        // 파일 유형을 정하기 위한 작업
        final String? mimeType = lookupMimeType(profileImage.path);
        final SettableMetadata metadata = SettableMetadata(
          contentType: mimeType,
        );
        // 프로필 이미지 업로드를 위해 FirebaseStorage Reference 얻기
        Reference reference = firebaseStorage.ref().child('profile').child(uid);
        // 프로필 이미지 저장 > 저장될 때까지 기다리기 위해 await 키워드 사용
        final TaskSnapshot taskSnapshot = await reference.putFile(
          profileImage,
          metadata,
        );
        // 이미지 다운로드 경로
        profileImageUrl = await taskSnapshot.ref.getDownloadURL();
        // (Logger) 이미지 다운로드 경로
        logger.d(profileImageUrl);
      }

      // UserModel 생성
      UserModel userModel = UserModel(
        uid: uid,
        email: email,
        name: name,
        comment: comment,
        profileImage: profileImageUrl,
        feedCount: 0,
        followers: [],
        following: [],
        likes: [],
        bookmarks: [],
      );

      // Firestore 저장
      await firebaseFirestore
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());

      // FirebaseAuth 이미 로그인은 되었으나, 인증메일을 받지 않은 상태이므로 로그아웃 처리
      firebaseAuth.signOut();
    } catch (_) {
      rethrow;
    }
  }

  // [이메일 + 비밀번호] 기반 로그인 처리
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // FirebaseAuth 이용해서 [이메일 + 비밀번호] 기반 로그인
      // 메서드를 호출하면 자동으로 FirebaseAuth 자동 로그인 처리됨.
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // 인증메일 확인 여부
      bool isVerified = userCredential.user!.emailVerified;
      // 인증메일 인증하지 않았다면 인증메일 재발송 & 로그아웃

      if (!isVerified) {
        await userCredential.user!.sendEmailVerification();
        await firebaseAuth.signOut();
        throw Exception('인증되지 않은 이메일\n\n인증메일 확인 후에 로그인 가능합니다!');
      }
    } catch (_) {
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (_) {
      rethrow;
    }
  }

  // 실시간 사용자의 상태관리를 위한 Stream 기반 getter
  Stream<User?> get user {
    return firebaseAuth.authStateChanges().map((user) {
      return user == null ? null : firebaseAuth.currentUser;
    });
  }
}
