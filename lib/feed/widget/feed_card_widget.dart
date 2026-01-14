import 'package:flutter/material.dart';

import '/common/widget/chewie_widget.dart';
import '/common/widget/image_slider_widget.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/model/feed_model.dart';
import '/feed/widget/feed_action_widget.dart';
import '/feed/widget/feed_content_widget.dart';
import '/feed/widget/feed_header_widget.dart';

class FeedCardWidget extends StatelessWidget {
  // 피드 모델
  final FeedModel feedModel;

  // 생성자
  const FeedCardWidget({super.key, required this.feedModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 피드 Header
        FeedHeaderWidget(feedModel: feedModel),
        // 피드 이미지 또는 동영상
        feedModel.feedTypeEnum == FeedTypeEnum.image
            // 이미지 여러개를 슬라이드 형태로 보여주기
            ? ImageSliderWidget(images: feedModel.mediaUrls)
            // 동영상 보여주기
            : ChewieWidget(videoUrl: feedModel.mediaUrls[0]),
        // 피드 Actions (좋아요, 댓글, 메세지, 북마크)
        FeedActionWidget(feedModel: feedModel),
        // 피드 내용
        FeedContentWidget(feedModel: feedModel),
      ],
    );
  }
}
