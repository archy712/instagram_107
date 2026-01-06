import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/auth/model/user_model.dart';
import '/feed/enum/feed_type_enum.dart';

class FeedModel extends Equatable {
  // Feed ID
  final String feedId;
  // 작성자 uid
  final String uid;
  // Feed 내용
  final String feedContent;
  // Feed 미디어 경로들
  final List<String> mediaUrls;
  // Feed 미디어 타입 (text / image / video)
  final FeedTypeEnum feedTypeEnum;
  // 해당 Feed 좋아요 누른 사용자 uid 리스트
  final List<String> likes;
  // 해당 Feed 댓글 갯수
  final int commentCount;
  // 해당 Feed 좋아요 갯수
  final int likeCount;
  // 해당 Feed bookmark 처리한 uid
  final List<String> bookmarks;
  // 해당 Feed 전송한 숫자 (상세 보낸사람/받는사람은 별도 컬렉션으로 구성 필요)
  final int sendCount;
  // Feed 생성시간
  final Timestamp createdAt;
  // 작성자 사용자 모델
  final UserModel writer;

  // constructor
  const FeedModel({
    required this.feedId,
    required this.uid,
    required this.feedContent,
    required this.mediaUrls,
    required this.feedTypeEnum,
    required this.likes,
    required this.commentCount,
    required this.likeCount,
    required this.bookmarks,
    required this.sendCount,
    required this.createdAt,
    required this.writer,
  });

  // toMap()
  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
  }) {
    return {
      'feedId': feedId,
      'uid': uid,
      'feedContent': feedContent,
      'mediaUrls': mediaUrls,
      'feedTypeEnum': feedTypeEnum.name,
      'likes': likes,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'bookmarks': bookmarks,
      'sendCount': sendCount,
      'createdAt': createdAt,
      'writer': userDocRef,
    };
  }

  // fromMap()
  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      feedId: map['feedId'],
      uid: map['uid'],
      feedContent: map['feedContent'],
      mediaUrls: List<String>.from(map['mediaUrls']),
      feedTypeEnum: (map['feedTypeEnum'] as String).toEnum(),
      likes: List<String>.from(map['likes']),
      commentCount: map['commentCount'],
      likeCount: map['likeCount'],
      bookmarks: List<String>.from(map['bookmarks']),
      sendCount: map['sendCount'],
      createdAt: map['createdAt'],
      writer: map['writer'],
    );
  }

  // copyWith()
  FeedModel copyWith({
    String? feedId,
    String? uid,
    String? feedContent,
    List<String>? mediaUrls,
    FeedTypeEnum? feedTypeEnum,
    List<String>? likes,
    int? commentCount,
    int? likeCount,
    List<String>? bookmarks,
    int? sendCount,
    Timestamp? createdAt,
    UserModel? writer,
  }) {
    return FeedModel(
      feedId: feedId ?? this.feedId,
      uid: uid ?? this.uid,
      feedContent: feedContent ?? this.feedContent,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      feedTypeEnum: feedTypeEnum ?? this.feedTypeEnum,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      bookmarks: bookmarks ?? this.bookmarks,
      sendCount: sendCount ?? this.sendCount,
      createdAt: createdAt ?? this.createdAt,
      writer: writer ?? this.writer,
    );
  }

  // toString()
  @override
  String toString() {
    return 'FeedModel{feedId: $feedId, uid: $uid, feedContent: $feedContent, mediaUrls: $mediaUrls, feedTypeEnum: $feedTypeEnum, likes: $likes, commentCount: $commentCount, likeCount: $likeCount, bookmarks: $bookmarks, sendCount: $sendCount, createdAt: $createdAt, writer: $writer}';
  }

  // props []
  @override
  List<Object?> get props => [
    feedId,
    uid,
    feedContent,
    mediaUrls,
    feedTypeEnum,
    likes,
    commentCount,
    likeCount,
    bookmarks,
    sendCount,
    createdAt,
    writer,
  ];
}
