import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '/auth/model/user_model.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/widget/app_text.dart';

class ProfileHeaderWidget extends StatelessWidget {
  // 사용자 정보
  final UserModel userModel;

  const ProfileHeaderWidget({super.key, required this.userModel});

  // 숫자와 문자를 이용한 위젯
  Widget _numberAndTextWidget(String count, String label) {
    return Column(
      children: [
        AppText(count, fontSize: 18, fontWeight: FontWeight.bold),
        AppText(label, fontSize: 15, color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // --- 사용자 아바타 이미지 ---
              CircleAvatar(
                radius: 40,
                backgroundImage: userModel.profileImage == null
                    ? ExtendedAssetImageProvider('assets/images/avatar.jpg')
                    : ExtendedNetworkImageProvider(userModel.profileImage!),
                backgroundColor: Colors.grey,
              ),
              // --- 사용자 정보 요약 (내 피드/팔로워/팔로잉) ---
              _numberAndTextWidget(
                userModel.feedCount.toString(),
                S.current.profileSummeryFeed,
              ),
              _numberAndTextWidget(
                userModel.followers.length.toString(),
                S.current.profileSummeryFollower,
              ),
              _numberAndTextWidget(
                userModel.following.length.toString(),
                S.current.profileSummeryFollowing,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // --- 사용자 이름 ---
          AppText(userModel.name, fontWeight: FontWeight.bold, fontSize: 16),
          // --- 한줄 메모 ---
          AppText(userModel.comment),
          const SizedBox(height: 16),
          Row(
            children: [
              // --- 프로필 수정 버튼 ---
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: AppText(S.current.profileEditUserProfile),
                ),
              ),
              const SizedBox(width: 8),
              // --- 프로필 공유 버튼 ---
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: AppText(S.current.profileShareUserProfile),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
