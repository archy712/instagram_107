import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/model/user_model.dart';
import '/feed/model/feed_model.dart';
import '/feed/repository/feed_repository.dart';
import '/profile/repository/profile_repository.dart';
import '/profile/state/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  // Profile Repository
  final ProfileRepository profileRepository;

  // FeedRepository
  final FeedRepository feedRepository;

  // constructor
  ProfileCubit({required this.profileRepository, required this.feedRepository})
    : super(ProfileState.init());

  // Profile 정보 가져오기
  Future<void> getProfile({required String uid}) async {
    // 먼저 진행상태 변경
    emit(state.copyWith(profileStatusEnum: ProfileStatusEnum.fetching));
    try {
      // 1> 프로필 화면의 대상 사용자 모델
      UserModel userModel = await profileRepository.getUserModel(uid: uid);

      // 2> 사용자가 작성한 피드 리스트
      List<FeedModel> feedList = await feedRepository.getFeedList(uid: uid);

      // 3> 사용자의 좋아요 처리된 피드 리스트
      List<FeedModel> likeFeedList = await feedRepository.getLikeFeedList(
        uid: uid,
      );

      // 4> 사용자의 북마크 처리된 피드 리스트
      List<FeedModel> bookmarkFeedList = await feedRepository
          .getBookmarkFeedList(uid: uid);

      // 상태관리 업데이트
      emit(
        state.copyWith(
          profileStatusEnum: ProfileStatusEnum.success,
          userModel: userModel,
          feedList: feedList,
          likeFeedList: likeFeedList,
          bookmarkFeedList: bookmarkFeedList,
        ),
      );
    } catch (_) {
      // 실패 시 상태관리 실패로 업데이트
      emit(state.copyWith(profileStatusEnum: ProfileStatusEnum.error));
      // 호출한 곳으로 에러 위임
      rethrow;
    }
  }
}
