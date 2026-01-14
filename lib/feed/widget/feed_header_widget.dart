import 'package:flutter/material.dart';

import '/common/util/locale/generated/l10n.dart';
import '/feed/model/feed_model.dart';
import '/feed/widget/small_avatar_widget.dart';

class FeedHeaderWidget extends StatelessWidget {
  // FeedModel
  final FeedModel feedModel;
  // 생성자
  const FeedHeaderWidget({super.key, required this.feedModel});

  @override
  Widget build(BuildContext context) {
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
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              side: BorderSide(color: Colors.grey[700]!),
            ),
            child: Text(S.current.feedFollow),
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
    );
  }
}
