import 'package:loader_overlay/loader_overlay.dart';

import '/main.dart';

class GlobalLoading {
  // context 없을 경우 프로그램 어디에서도 로딩을 호출할 수 있도록
  static void showLoading(bool isLoading) {
    isLoading
        ? navigatorKey.currentContext!.loaderOverlay.show()
        : navigatorKey.currentContext!.loaderOverlay.hide();
  }
}
