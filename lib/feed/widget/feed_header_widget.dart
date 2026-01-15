import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/auth/model/user_model.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/common_outlined_button.dart';
import '/common/widget/dialog_widget.dart';
import '/feed/model/feed_model.dart';
import '/feed/widget/small_avatar_widget.dart';

class FeedHeaderWidget extends StatelessWidget {
  // FeedModel
  final FeedModel feedModel;
  // 생성자
  const FeedHeaderWidget({super.key, required this.feedModel});

  // 팔로우 / 팔로잉 처리
  Future<void> _followAndFollowing(
    BuildContext context,
    String currentUserUid,
  ) async {
    try {
      await context.read<UserCubit>().followUser(
        currentUserUid: currentUserUid,
        followUid: feedModel.uid,
      );
    } catch (e, stackTrace) {
      // 커맨드창에 상세 오류 표시
      logger.e(stackTrace.toString());
      // Dialog Box
      DialogWidget.showAlertDialog(
        title: S.current.feedFollowFollowingError,
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 접속한 사용자 정보
    final UserModel currentUserModel = context
        .watch<UserCubit>()
        .state
        .userModel;
    // 팔로우 / 팔로잉 버튼 여부
    bool isFollow = false;
    // 팔로우 여부 확인
    if (currentUserModel.following.contains(feedModel.uid)) {
      isFollow = true;
    }
    //logger.i('currentUserModel: ${currentUserModel.toString()}');
    //logger.i('isFollow: $isFollow');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SmallAvatarWidget(userModel: feedModel.writer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feedModel.writer.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // 현재 접속한 사용자의 피드가 아닐 경우에만 팔로우/팔로잉 버튼 표시
          if (currentUserModel.uid != feedModel.uid)
            // OutlinedButton(
            //   onPressed: () {},
            //   style: OutlinedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     side: BorderSide(color: Colors.grey[700]!),
            //   ),
            //   child: Text(S.current.feedFollow),
            // ),
            // 현재 접속한 사용자의 피드가 아닐 경우에만 팔로우/팔로잉 버튼 표시
            CommonOutlinedButton(
              asyncCallback: () =>
                  _followAndFollowing(context, currentUserModel.uid),
              buttonTitle: isFollow
                  ? S.current.feedFollowing
                  : S.current.feedFollow,
              backgroundColor: isFollow ? Colors.orange : Colors.transparent,
            ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
    );
  }
}
