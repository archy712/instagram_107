import 'package:equatable/equatable.dart';

import '/feed/model/feed_model.dart';

// 피드 진행상태
enum FeedStatusEnum {
  // 초기 상태
  init,
  // 피드 등록하는 중
  submitting,
  // 피드 가져오는 중
  fetching,
  // 피드 등록 완료
  success,
  // 피드 오류
  error,
}

// 피드 상태관리 데이터
class FeedState extends Equatable {
  // 피드 진행상태
  final FeedStatusEnum feedStatusEnum;

  // 상단 Top Feed List
  final List<FeedModel> recentlyFeedList;

  // 피드 목록
  final List<FeedModel> feedList;

  // 생성자
  const FeedState({
    required this.feedStatusEnum,
    required this.recentlyFeedList,
    required this.feedList,
  });
  // factory init() constructor
  factory FeedState.init() {
    return FeedState(
      feedStatusEnum: FeedStatusEnum.init,
      recentlyFeedList: [],
      feedList: [],
    );
  }
  // copyWith method
  FeedState copyWith({
    FeedStatusEnum? feedStatusEnum,
    List<FeedModel>? recentlyFeedList,
    List<FeedModel>? feedList,
  }) {
    return FeedState(
      feedStatusEnum: feedStatusEnum ?? this.feedStatusEnum,
      recentlyFeedList: recentlyFeedList ?? this.recentlyFeedList,
      feedList: feedList ?? this.feedList,
    );
  }

  @override
  List<Object?> get props => [feedStatusEnum, recentlyFeedList, feedList];
}
