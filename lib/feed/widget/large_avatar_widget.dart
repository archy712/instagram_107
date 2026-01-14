import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '/auth/model/user_model.dart';
import '/common/widget/app_text.dart';

class LargeAvatarWidget extends StatelessWidget {
  // 사용자 모델
  final UserModel userModel;
  // 현재 접속중인 사용자 여부
  final bool isMe;
  // 생성자
  const LargeAvatarWidget({
    super.key,
    required this.userModel,
    this.isMe = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isMe
                  ? Border.all(color: Colors.transparent, width: 3.0)
                  : Border.all(color: Colors.pink, width: 3.0),
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userModel.profileImage == null
                      ? ExtendedAssetImageProvider('assets/images/profile.png')
                      : ExtendedNetworkImageProvider(userModel.profileImage!),
                  backgroundColor: Colors.grey,
                ),
                // 현재 작성자는 + 표시를 보여주기
                if (isMe)
                  Positioned(
                    // 왼쪽에서 오른쪽으로 80 만큼 이동
                    left: 40,
                    // 아래에서 위로 10만큼
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.0),
                      ),
                      child: Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 20,
            child: AppText(
              userModel.name,
              fontSize: 12,
              // 텍스트가 넘칠 경우 생략 부호(...) 처리
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
