import 'package:flutter/material.dart';

import '/feed/model/feed_model.dart';
import '/feed/widget/feed_card_widget.dart';

class ProfileFeedScreen extends StatefulWidget {
  // 피드 모델
  final FeedModel feedModel;

  // constructor
  const ProfileFeedScreen({super.key, required this.feedModel});

  @override
  State<ProfileFeedScreen> createState() => _ProfileFeedScreenState();
}

class _ProfileFeedScreenState extends State<ProfileFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피드 상세'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        // 동영상의 경우 화면을 넘어가면 스크롤이 되어야 함.
        child: SingleChildScrollView(
          child: FeedCardWidget(feedModel: widget.feedModel),
        ),
      ),
    );
  }
}
