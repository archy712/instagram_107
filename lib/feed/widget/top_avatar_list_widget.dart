import 'package:flutter/material.dart';

import '/auth/model/user_model.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/widget/app_text.dart';
import '/feed/model/feed_model.dart';
import '/feed/widget/large_avatar_widget.dart';

class TopAvatarListWidget extends StatelessWidget {
  // 현재 접속중인 사용자 모델
  final UserModel currentUserModel;
  // 최신 피드 리스트
  final List<FeedModel> recentlyFeedList;
  const TopAvatarListWidget({
    super.key,
    required this.recentlyFeedList,
    required this.currentUserModel,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 110,
        child: recentlyFeedList.isEmpty
            ? Center(child: AppText(S.current.feedNoFeedList))
            : Row(
                children: [
                  LargeAvatarWidget(userModel: currentUserModel, isMe: true),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentlyFeedList.length,
                      itemBuilder: (context, index) {
                        FeedModel feedModel = recentlyFeedList[index];
                        return LargeAvatarWidget(userModel: feedModel.writer);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
