import 'package:flutter/material.dart';

import '/common/util/locale/generated/l10n.dart';
import '/feed/model/feed_model.dart';
import '/profile/widget/bookmark_tab_widget.dart';
import '/profile/widget/feed_tab_widget.dart';
import '/profile/widget/like_tab_widget.dart';

class ProfileBodyWidget extends StatelessWidget {
  // 프로필 피드 리스트
  final List<FeedModel> feedList;

  // 프로필 좋아요 리스트
  final List<FeedModel> likeFeedList;

  // 프로필 북마크 리스트
  final List<FeedModel> bookmarkFeedList;

  const ProfileBodyWidget({
    super.key,
    required this.feedList,
    required this.likeFeedList,
    required this.bookmarkFeedList,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Feed 탭, Like 탭, BookMark 탭
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              // 내 피드
              Tab(icon: Icon(Icons.feed), text: S.current.profileTabMyFeed),
              // 좋아요
              Tab(icon: Icon(Icons.favorite), text: S.current.profileTabLike),
              // 북마크
              Tab(
                icon: Icon(Icons.bookmark),
                text: S.current.profileTabBookmark,
              ),
            ],
          ),
          SizedBox(
            // 실제 콘텐츠 높이에 따라 조절 필요
            height: 400,
            child: TabBarView(
              children: [
                // Feed 탭
                FeedTabWidget(feedList: feedList),
                // Like (좋아요) 탭
                LikeTabWidget(likeFeedList: likeFeedList),
                // Bookmark (북마크) 탭
                BookmarkTabWidget(bookmarkFeedList: bookmarkFeedList),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
