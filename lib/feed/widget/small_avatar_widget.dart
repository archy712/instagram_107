import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '/auth/model/user_model.dart';

class SmallAvatarWidget extends StatelessWidget {
  // 사용자 모델
  final UserModel userModel;

  const SmallAvatarWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: userModel.profileImage == null
          ? ExtendedAssetImageProvider('assets/images/profile.png')
          : ExtendedNetworkImageProvider(userModel.profileImage!),
      backgroundColor: Colors.grey,
    );
  }
}
