import 'dart:io';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  // 생성자에서 현재 기기의 로케일로 초기화
  LocaleCubit() : super(Locale(Platform.localeName.split('_')[0]));

  // Locale 변경
  void changeLocale({required Locale locale}) {
    emit(locale);
  }
}
