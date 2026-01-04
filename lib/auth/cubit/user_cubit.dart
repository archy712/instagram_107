import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/model/user_model.dart';
import '/auth/repository/user_repository.dart';
import '/auth/state/user_state.dart';

class UserCubit extends Cubit<UserState> {
  // UserRepository
  final UserRepository userRepository;

  // constructor
  UserCubit({required this.userRepository}) : super(UserState.init());

  // 현재 접속한 사용자 모델 얻기
  Future<void> getCurrentUser() async {
    // 작업중 상태로 먼저 변경
    emit(state.copyWith(userStatusEnum: UserStatusEnum.fetching));

    try {
      // Repository 이용해서 데이터 조회
      final UserModel currentUserModel = await userRepository.getCurrentUser();

      // 가져온 데이터로 상태관리 데이터 변경
      emit(
        state.copyWith(
          userStatusEnum: UserStatusEnum.success,
          userModel: currentUserModel,
        ),
      );
    } catch (_) {
      // 데이터 가져오기 실패로 상태관리 데이터 변경
      emit(state.copyWith(userStatusEnum: UserStatusEnum.error));

      // 데이터 오류 처리 위임
      rethrow;
    }
  }
}
