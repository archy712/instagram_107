import 'package:flutter/material.dart';

import '/feed/model/feed_model.dart';

class FeedContentWidget extends StatelessWidget {
  // 피드 모델
  final FeedModel feedModel;

  // 생성자
  const FeedContentWidget({super.key, required this.feedModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(feedModel.feedContent),
    );
  }
}
