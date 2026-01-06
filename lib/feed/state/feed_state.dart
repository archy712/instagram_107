import 'package:equatable/equatable.dart';

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
  // 생성자
  const FeedState({required this.feedStatusEnum});

  // factory init() constructor
  factory FeedState.init() {
    return FeedState(feedStatusEnum: FeedStatusEnum.init);
  }

  // copyWith method
  FeedState copyWith({FeedStatusEnum? feedStatusEnum}) {
    return FeedState(feedStatusEnum: feedStatusEnum ?? this.feedStatusEnum);
  }

  @override
  List<Object?> get props => [feedStatusEnum];
}
