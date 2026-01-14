import 'package:flutter_bloc/flutter_bloc.dart';

import '/common/util/logger.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/model/feed_model.dart';
import '/feed/repository/feed_repository.dart';
import '/feed/state/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  // FeedRepository
  final FeedRepository feedRepository;

  // constructor
  FeedCubit({required this.feedRepository}) : super(FeedState.init());

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
}
