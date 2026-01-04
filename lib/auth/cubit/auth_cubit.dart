import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/repository/auth_repository.dart';
import '/auth/state/auth_state.dart';
import '/common/util/logger.dart';

class AuthCubit extends Cubit<AuthState> {
  // AuthRepository 사용
  final AuthRepository authRepository;
  // constructor
  AuthCubit({required this.authRepository}) : super(AuthState.init()) {
    // constructor 에서 lazy 옵션 false 로 바로 인스턴스화 > 바로 실행
    authRepository.user.listen((user) => _refreshAuthenticated(user));
  }

  // 사용자의 인증 상태를 실시간 갱신을 위한 함수
  void _refreshAuthenticated(User? user) {
    // 사용자 정보가 없고 인증상태 값이 미인증이라면 리턴
    if (user == null &&
        state.authCurrentStatusEnum == AuthCurrentStatusEnum.unAuthenticated) {
      return;
    }

    // 인증받지 않은 이메일로 로그인 시도를 할 때 리턴 처리
    if (user != null && !user.emailVerified) {
      return;
    }

    // 모두 통과했다면 인증상태 업데이트
    emit(
      state.copyWith(
        authCurrentStatusEnum: user != null
            ? AuthCurrentStatusEnum.authenticated
            : AuthCurrentStatusEnum.unAuthenticated,
      ),
    );
  }

  // [이메일 + 비밀번호] 기반 회원 가입
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String name,
    required String comment,
    required String password,
    required File? profileImage,
  }) async {
    // 먼저 상태관리 데이터를 진행중으로 변경
    emit(
      state.copyWith(authProgressStatusEnum: AuthProgressStatusEnum.submitting),
    );

    try {
      // Repository 이용하여 [이메일 + 비밀번호] 기반 회원가입 요청
      await authRepository.signUpWithEmailAndPassword(
        email: email,
        name: name,
        comment: comment,
        password: password,
        profileImage: profileImage,
      );
      // 성공적으로 되었다면 상태관리 데이터를 성공으로 변경
      emit(
        state.copyWith(
          authProgressStatusEnum: AuthProgressStatusEnum.success,
          // 나중에 이메일 확인 시에 처리 예정
          // authCurrentStatusEnum: AuthCurrentStatus.authenticated,
        ),
      );
      logger.d(
        'authProgressStatusEnum: ${AuthProgressStatusEnum.success.toString()}',
      );
    } catch (_) {
      // 에러 발생 시 상태관리 데이터 처리
      emit(
        state.copyWith(authProgressStatusEnum: AuthProgressStatusEnum.error),
      );
      // 호출한 곳으로 에러 위임
      rethrow;
    }
  }

  // [이메일 + 비밀번호] 기반 로그인
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // 먼저 상태관리 데이터를 [진행중]으로 변경
    emit(
      state.copyWith(authProgressStatusEnum: AuthProgressStatusEnum.submitting),
    );

    try {
      // AuthRepository 이용해서 로그인 처리
      await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 성공적으로 로그인 되었다면 2가지 상태관리 데이터 업데이트 : [로그인성공], [인증됨]
      emit(
        state.copyWith(
          authProgressStatusEnum: AuthProgressStatusEnum.success,
          authCurrentStatusEnum: AuthCurrentStatusEnum.authenticated,
        ),
      );
    } catch (_) {
      // 먼저 상태관리 데이터를 [실패]로 변경
      emit(
        state.copyWith(authProgressStatusEnum: AuthProgressStatusEnum.error),
      );
      // 호출한 곳으로 에러처리 위임
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      // AuthRepository 이용하여 로그아웃
      await authRepository.signOut();

      // 로그아웃이 되었다면 [미인증] 상태로 상태 업데이트
      emit(
        state.copyWith(
          authProgressStatusEnum: AuthProgressStatusEnum.init,
          authCurrentStatusEnum: AuthCurrentStatusEnum.unAuthenticated,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }
}
