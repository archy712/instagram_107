import 'package:instagram_107/common/util/locale/generated/l10n.dart';

// 피드 타입
enum FeedTypeEnum { text, image, video }

// String 확장 기능 : toEnum()
extension ConvertMessage on String {
  FeedTypeEnum toEnum() {
    switch (this) {
      case 'text':
        return FeedTypeEnum.text;
      case 'image':
        return FeedTypeEnum.image;
      default:
        return FeedTypeEnum.video;
    }
  }
}

// MessageEnum 확장 기능 : toText()
extension ConvertString on FeedTypeEnum {
  String toText() {
    switch (this) {
      case FeedTypeEnum.image:
        return '📷 ${S.current.newFeedTypeImage}';
      case FeedTypeEnum.video:
        return '🎬 ${S.current.newFeedTypeVideo}';
      case FeedTypeEnum.text:
        return 'TEXT';
    }
  }
}
