import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '/common/widget/chewie_widget.dart';
import '/common/widget/image_slider_widget.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/model/feed_model.dart';
import '/profile/screen/profile_feed_screen.dart';

class BookmarkTabWidget extends StatelessWidget {
  // 북마크 피드 리스트
  final List<FeedModel> bookmarkFeedList;

  const BookmarkTabWidget({super.key, required this.bookmarkFeedList});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      itemCount: bookmarkFeedList.length,
      itemBuilder: (context, index) {
        final FeedModel feedModel = bookmarkFeedList[index];
        return feedModel.mediaUrls.isNotEmpty
            ? feedModel.feedTypeEnum == FeedTypeEnum.video
                  ? ChewieWidget(
                      videoUrl: feedModel.mediaUrls[0],
                      isProfileScreen: true,
                      onTap: () {
                        // 피드 상세 화면 (FeedCardWidget)으로 라우팅
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileFeedScreen(feedModel: feedModel),
                          ),
                        );
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        // 피드 상세 화면 (FeedCardWidget)으로 라우팅
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileFeedScreen(feedModel: feedModel),
                          ),
                        );
                      },
                      child: ImageSliderWidget(
                        images: feedModel.mediaUrls,
                        isProfileScreen: true,
                      ),
                    )
            : Image.asset('assets/images/feed_1.jpg', fit: BoxFit.cover);
      },
    );
  }
}
