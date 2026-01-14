import 'package:flutter/material.dart';

import '/feed/model/feed_model.dart';

class FeedActionWidget extends StatelessWidget {
  // 피드 모델
  final FeedModel feedModel;

  // 생성자
  const FeedActionWidget({super.key, required this.feedModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          // 좋아요 아이콘
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
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
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
    );
  }
}
