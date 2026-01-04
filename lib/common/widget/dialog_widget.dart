import 'package:flutter/material.dart';

import '/common/widget/app_text.dart';
import '/main.dart';

class DialogWidget {
  static Future<void> showAlertDialog({
    required String title,
    required String msg,
  }) async {
    await showDialog(
      // Dialog 위젯 바깥 부분을 터치해도 다이얼로그 위젯이 닫히지 않음
      barrierDismissible: false,
      // showAlertDialog() 호출되는 쪽의 context
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          // 타이틀
          title: AppText(title),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const AppText('확인'),
            ),
          ],
        );
      },
    );
  }
}
