import 'package:equatable/equatable.dart';

import '/auth/model/user_model.dart';

// 사용자 진행 상태
enum UserStatusEnum {
  // 초기 상태
  init,
  // 데이터 처리 중
  submitting,
  // 데이터 가져오는 중
  fetching,
  // 성공
  success,
  // 에러
  error,
}

// 사용자 상태관리 데이터
class UserState extends Equatable {
  // 사용자 진행 상태
  final UserStatusEnum userStatusEnum;

  // 현재 접속한 사용자 모델 클래스
  final UserModel userModel;

  // constructor
  const UserState({required this.userStatusEnum, required this.userModel});

  // factory init() constructor
  factory UserState.init() {
    return UserState(
      userStatusEnum: UserStatusEnum.init,
      userModel: UserModel.init(),
    );
  }

  // copyWith() method
  UserState copyWith({UserStatusEnum? userStatusEnum, UserModel? userModel}) {
    return UserState(
      userStatusEnum: userStatusEnum ?? this.userStatusEnum,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [userStatusEnum, userModel];
}
