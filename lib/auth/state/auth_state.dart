import 'package:equatable/equatable.dart';

// 사용자 작업 진행 상태 Enum
enum AuthProgressStatusEnum {
  // 초기 상태
  init,
  // 처리 중
  submitting,
  // 데이터 가져오는 중
  fetching,
  // 작업 성공
  success,
  // 작업 실패
  error,
}

// 사용자 인증 상태 Enum
enum AuthCurrentStatusEnum {
  // 미인증 상태
  unAuthenticated,
  // 인증 상태
  authenticated,
}

// 사용자 상태관리 데이터 클래스
class AuthState extends Equatable {
  // 작업 진행 상태
  final AuthProgressStatusEnum authProgressStatusEnum;
  // 인증 상태
  final AuthCurrentStatusEnum authCurrentStatusEnum;

  // constructor
  const AuthState({
    required this.authProgressStatusEnum,
    required this.authCurrentStatusEnum,
  });

  // factory init() constructor
  factory AuthState.init() {
    return AuthState(
      authProgressStatusEnum: AuthProgressStatusEnum.init,
      authCurrentStatusEnum: AuthCurrentStatusEnum.unAuthenticated,
    );
  }

  // copyWith()
  AuthState copyWith({
    AuthProgressStatusEnum? authProgressStatusEnum,
    AuthCurrentStatusEnum? authCurrentStatusEnum,
  }) {
    return AuthState(
      authProgressStatusEnum:
          authProgressStatusEnum ?? this.authProgressStatusEnum,
      authCurrentStatusEnum:
          authCurrentStatusEnum ?? this.authCurrentStatusEnum,
    );
  }

  @override
  String toString() {
    return 'AuthState{authProgressStatusEnum: $authProgressStatusEnum, authCurrentStatusEnum: $authCurrentStatusEnum}';
  }

  @override
  List<Object?> get props => [authProgressStatusEnum, authCurrentStatusEnum];
}
