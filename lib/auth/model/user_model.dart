import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  // 사용자 uid
  final String uid;

  // 사용자 이름
  final String name;

  // 한 줄 소개
  final String comment;

  // 사용자 이메일
  final String email;

  // 프로필 이미지 URL
  final String? profileImage;

  // 사용자가 작성한 feed 갯수
  final int feedCount;

  // 사용자를 following 하는 유저들의 uid 리스트
  final List<String> followers;

  // 사용자가 following 하는 유저들에 대한 uid 리스트
  final List<String> following;

  // 사용자가 좋아요 누른 feedId 리스트
  final List<String> likes;

  // 사용자가 북마크 누른 feedId 리스트
  final List<String> bookmarks;

  // constructor
  const UserModel({
    required this.uid,
    required this.name,
    required this.comment,
    required this.email,
    this.profileImage,
    required this.feedCount,
    required this.followers,
    required this.following,
    required this.likes,
    required this.bookmarks,
  });

  // factory init() constructor
  factory UserModel.init() {
    return UserModel(
      uid: '',
      name: '',
      comment: '',
      email: '',
      profileImage: null,
      feedCount: 0,
      followers: [],
      following: [],
      likes: [],
      bookmarks: [],
    );
  }

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'comment': comment,
      'email': email,
      'profileImage': profileImage,
      'feedCount': feedCount,
      'followers': followers,
      'following': following,
      'likes': likes,
      'bookmarks': bookmarks,
    };
  }

  // fromMap()
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      comment: map['comment'],
      email: map['email'],
      profileImage: map['profileImage'],
      feedCount: map['feedCount'],
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      likes: List<String>.from(map['likes']),
      bookmarks: List<String>.from(map['bookmarks']),
    );
  }

  // copyWith()
  UserModel copyWith({
    String? uid,
    String? name,
    String? comment,
    String? email,
    String? profileImage,
    int? feedCount,
    List<String>? followers,
    List<String>? following,
    List<String>? likes,
    List<String>? bookmarks,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      feedCount: feedCount ?? this.feedCount,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likes: likes ?? this.likes,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  // toString()
  @override
  String toString() {
    return 'UserModel{uid: $uid, name: $name, comment: $comment, email: $email, profileImage: $profileImage, feedCount: $feedCount, followers: $followers, following: $following, likes: $likes, bookmarks: $bookmarks}';
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    comment,
    email,
    profileImage,
    feedCount,
    followers,
    following,
    likes,
    bookmarks,
  ];
}
