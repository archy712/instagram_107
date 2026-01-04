import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/repository/auth_repository.dart';
import '/auth/state/auth_state.dart';
import '/common/util/logger.dart';

class AuthCubit extends Cubit<AuthState> {
  // AuthRepository 사용
  final AuthRepository authRepository;
  // constructor
  AuthCubit({required this.authRepository}) : super(AuthState.init());

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
}
