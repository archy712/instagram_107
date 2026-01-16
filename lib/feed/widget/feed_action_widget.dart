import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/dialog_widget.dart';
import '/feed/cubit/feed_cubit.dart';
import '/feed/model/feed_model.dart';
import '/feed/state/feed_state.dart';

class FeedActionWidget extends StatelessWidget {
  // 피드 모델
  final FeedModel feedModel;

  // 생성자
  const FeedActionWidget({super.key, required this.feedModel});

  // 좋아요 기능
  Future<void> _likeFeed(BuildContext context) async {
    // feed 처리 진행중인 상태라면 리턴
    if (context.read<FeedCubit>().state.feedStatusEnum ==
        FeedStatusEnum.submitting) {
      return;
    }
    try {
      await context.read<FeedCubit>().likeFeed(
        feedId: feedModel.feedId,
        feedLikes: feedModel.likes,
      );

      // 상태관리 데이터에 새롭게 바뀐 users 반영
      if (context.mounted) {
        await context.read<UserCubit>().getCurrentUser();
      }
    } catch (e, stackTrace) {
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(
        title: S.current.feedLikeError,
        msg: e.toString(),
      );
    }
  }

  // 북마크 기능
  Future<void> _bookmarkFeed(BuildContext context) async {
    // feed 처리 진행중인 상태라면 리턴
    if (context.read<FeedCubit>().state.feedStatusEnum ==
        FeedStatusEnum.submitting) {
      return;
    }
    try {
      await context.read<FeedCubit>().bookmarkFeed(
        feedId: feedModel.feedId,
        feedBookmarks: feedModel.bookmarks,
      );
      // 상태관리 데이터에 새롭게 바뀐 users 반영
      if (context.mounted) {
        await context.read<UserCubit>().getCurrentUser();
      }
    } catch (e, stackTrace) {
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(
        title: S.current.feedBookmarkError,
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 접속중인 유저의 uid
    final String currentUserUid = context.read<UserCubit>().state.userModel.uid;

    // 현재 접속중인 유저의 uid가 피드의 likes에 들어있는지 판단
    bool isLike = feedModel.likes.contains(currentUserUid);

    // 현재 접속중인 유저의 uid 가 피드의 bookmarks 에 들어있는지 판단
    bool isBookmark = feedModel.bookmarks.contains(currentUserUid);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          // 좋아요 아이콘
          IconButton(
            icon: isLike
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border),
            onPressed: () async {
              await _likeFeed(context);
            },
          ),
          // 좋아요 갯수
          Text(
            feedModel.likeCount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // 댓글 아이콘
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
          // 댓글 수
          Text(
            feedModel.commentCount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // 메시지 아이콘
          IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
          // 메시지 수
          Text(
            feedModel.sendCount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // 북마크 아이콘
          IconButton(
            icon: isBookmark
                ? Icon(Icons.bookmark, color: Colors.red)
                : Icon(Icons.bookmark_border),
            onPressed: () async {
              await _bookmarkFeed(context);
            },
          ),
        ],
      ),
    );
  }
}
