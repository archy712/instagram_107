import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_text.dart';

class CommonOutlinedButton extends StatelessWidget {
  // 버튼 누를 시 실행할 함수
  final AsyncCallback asyncCallback;
  // 버튼 타이틀
  final String buttonTitle;
  // 버튼 컬러
  final Color? backgroundColor;

  const CommonOutlinedButton({
    super.key,
    required this.asyncCallback,
    required this.buttonTitle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      // 실행할 함수
      onPressed: asyncCallback,
      // 버튼 스타일 (컬러, 테두리, 모양)
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      // 타이틀
      child: AppText(buttonTitle),
    );
  }
}
