import 'package:flutter_bloc/flutter_bloc.dart';

import '/common/util/logger.dart';
import '/feed/enum/feed_type_enum.dart';
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
      await feedRepository.uploadFeed(
        feedMedias: feedMedias,
        feedContent: feedContent,
        feedTypeEnum: feedTypeEnum,
      );
      // 피드 업로드 상태 변경 (업로드 완료)
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.success));
    } catch (_) {
      // 피드 업로드 상태 변경 (오류)
      emit(state.copyWith(feedStatusEnum: FeedStatusEnum.error));
      rethrow;
    }
  }
}
