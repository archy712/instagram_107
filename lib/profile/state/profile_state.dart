import 'package:equatable/equatable.dart';

import '/auth/model/user_model.dart';
import '/feed/model/feed_model.dart';

// 프로필 데이터 진행 상태
enum ProfileStatusEnum {
  // 처음 생성
  init,
  // 작업 진행 중
  submitting,
  // 데이터 가져오는 중
  fetching,
  // 작업 성공
  success,
  // 에러 발생
  error,
}

// 프로필 상태관리 데이터
class ProfileState extends Equatable {
  // 프로필 데이터 진행 상태
  final ProfileStatusEnum profileStatusEnum;

  // 사용자 정보
  final UserModel userModel;

  // 사용자 작성한 피드 리스트
  final List<FeedModel> feedList;

  // 사용자 좋아요 피드 리스트
  final List<FeedModel> likeFeedList;

  // 사용자 북마크 피드 리스트
  final List<FeedModel> bookmarkFeedList;

  // constructor
  const ProfileState({
    required this.profileStatusEnum,
    required this.userModel,
    required this.feedList,
    required this.likeFeedList,
    required this.bookmarkFeedList,
  });

  // factory init() constructor
  factory ProfileState.init() {
    return ProfileState(
      profileStatusEnum: ProfileStatusEnum.init,
      userModel: UserModel.init(),
      feedList: [],
      likeFeedList: [],
      bookmarkFeedList: [],
    );
  }

  // copyWith() method
  ProfileState copyWith({
    ProfileStatusEnum? profileStatusEnum,
    UserModel? userModel,
    List<FeedModel>? feedList,
    List<FeedModel>? likeFeedList,
    List<FeedModel>? bookmarkFeedList,
  }) {
    return ProfileState(
      profileStatusEnum: profileStatusEnum ?? this.profileStatusEnum,
      userModel: userModel ?? this.userModel,
      feedList: feedList ?? this.feedList,
      likeFeedList: likeFeedList ?? this.likeFeedList,
      bookmarkFeedList: bookmarkFeedList ?? this.bookmarkFeedList,
    );
  }

  // props
  @override
  List<Object?> get props => [
    profileStatusEnum,
    userModel,
    feedList,
    likeFeedList,
    bookmarkFeedList,
  ];
}
