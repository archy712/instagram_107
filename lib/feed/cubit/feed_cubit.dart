import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/model/user_model.dart';
import '/auth/repository/user_repository.dart';
import '/common/util/logger.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/model/feed_model.dart';
import '/feed/repository/feed_repository.dart';
import '/feed/state/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  // FeedRepository
  final FeedRepository feedRepository;

  // UserRepository
  final UserRepository userRepository;

  // constructor
  FeedCubit({required this.feedRepository, required this.userRepository})
    : super(FeedState.init());

  // 피드 등록
  Future<void> uploadFeed({
    required List<String> feedMedias,
    required String feedContent,
    required FeedTypeEnum feedTypeEnum,
  }) async {
    logger.d('feedTypeEnum : $feedTypeEnum');
    // 피드 업로드 상태 변경 (업로드 중)
    emit(state.copyWith(feedStatusEnum: FeedStatusEnum.submitting));

    try {
      FeedModel newFeedModel = await feedRepository.uploadFeed(
        feedMedias: feedMedias,
        feedContent: feedContent,
        feedTypeEnum: feedTypeEnum,
      );
      // 피드 업로드 상태 변경 (업로드 완료)
      emit(
        state.copyWith(
          feedStatusEnum: FeedStatusEnum.success,
          recentlyFeedList: [newFeedModel, ...state.recentlyFeedList],
          feedList: [newFeedModel, ...state.feedList],
        ),
      );
    } catch (_) {
      // 피드 업로드 상태 변경 (오류)
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      rethrow;
    }
  }

  // 최신 피드 목록을 조회 후 상태관리에 저장
  Future<void> getRecentlyFeedList({required int count}) async {
    // 먼저, 상태를 [fetching] 상태로 변경
    emit(state.copyWith(feedStatusEnum: FeedStatusEnum.fetching));
    try {
      // 최신 Feed 목록 조회
      List<FeedModel> recentlyFeedList = await feedRepository
          .getRecentlyFeedList(count: count);
      // 상태관리 데이터 갱신
      emit(
        state.copyWith(
          feedStatusEnum: FeedStatusEnum.success,
          recentlyFeedList: recentlyFeedList,
        ),
      );
    } catch (_) {
      // 실패 시 [error] 상태로 변경
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      // 에러 발생 시 처리한 곳으로 위임
      rethrow;
    }
  }

  // 피드 목록을 조회 후 상태관리에 저장
  Future<void> getFeedList() async {
    // 먼저, 상태를 [fetching] 상태로 변경
    emit(state.copyWith(feedStatusEnum: FeedStatusEnum.fetching));
    try {
      // Feed 목록 조회
      List<FeedModel> feedList = await feedRepository.getFeedList();
      // 상태관리 데이터 갱신
      emit(
        state.copyWith(
          feedStatusEnum: FeedStatusEnum.success,
          feedList: feedList,
        ),
      );
    } catch (_) {
      // 실패 시 [error] 상태로 변경
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      // 에러 발생 시 처리한 곳으로 위임
      rethrow;
    }
  }

  // 좋아요 처리
  Future<void> likeFeed({
    // 피드 ID
    required String feedId,
    // 해당 피드를 좋아요 누른 유저들의 uid 리스트
    required List<String> feedLikes,
  }) async {
    // 먼저 진행상태를 submitting 으로 변경
    emit(state.copyWith(feedStatusEnum: FeedStatusEnum.submitting));
    try {
      // 현재 접속중인 사용자의 Model 객체 얻기
      UserModel userModel = await userRepository.getCurrentUser();

      // Repository 이용해서 like 처리
      FeedModel likedFeedModel = await feedRepository.likeFeed(
        feedId: feedId,
        feedLikes: feedLikes,
        uid: userModel.uid,
        userLikes: userModel.likes,
      );

      // 좋아요 처리한 feed는 기존 상태관리 값 feedList 에서 교체하여 새로운 feedList 구성
      List<FeedModel> newFeedList = state.feedList.map((feed) {
        return feed.feedId == feedId ? likedFeedModel : feed;
      }).toList();

      // 작업 후 진행상태를 success 로 변경
      emit(
        state.copyWith(
          feedStatusEnum: FeedStatusEnum.success,
          feedList: newFeedList,
        ),
      );
    } catch (_) {
      // 진행상태를 error로 업데이트
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      // 오류를 호출한 곳으로 위임
      rethrow;
    }
  }

  // 북마크 처리
  Future<void> bookmarkFeed({
    // 피드 ID
    required String feedId,
    // 해당 피드를 북마크 누른 유저들의 uid 리스트
    required List<String> feedBookmarks,
  }) async {
    // 먼저 진행상태를 submitting 으로 변경
    emit(state.copyWith(feedStatusEnum: FeedStatusEnum.submitting));
    try {
      // 현재 접속중인 사용자의 Model 객체 얻기
      UserModel userModel = await userRepository.getCurrentUser();
      // Repository 이용해서 bookmark 처리
      FeedModel bookmarkedFeedModel = await feedRepository.bookmarkFeed(
        feedId: feedId,
        feedBookmarks: feedBookmarks,
        uid: userModel.uid,
        userBookmarks: userModel.bookmarks,
      );
      // 북마크 처리한 feed 는 기존 feedList 에서 교체하여 새로운 feedList 구성
      List<FeedModel> newFeedList = state.feedList.map((feed) {
        return feed.feedId == feedId ? bookmarkedFeedModel : feed;
      }).toList();
      // 작업 후 진행상태를 success 로 변경
      emit(
        state.copyWith(
          feedStatusEnum: FeedStatusEnum.success,
          feedList: newFeedList,
        ),
      );
    } catch (_) {
      // 진행상태를 error 로 업데이트
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      // 오류를 호출한 곳으로 위임
      rethrow;
    }
  }
}
