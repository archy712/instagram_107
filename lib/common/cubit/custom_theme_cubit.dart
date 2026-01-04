import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/common/state/custom_theme_state.dart';
import '/common/theme/app_theme_data.dart';

class CustomThemeCubit extends Cubit<CustomThemeState> {
  // 생성자 : 부모클래스 생성자로 상태 초기화
  CustomThemeCubit() : super(CustomThemeState.init());

  // 테마 변경하기
  void toggleThemeMode() {
    // 현재 테마모드를 알아내 테마모드를 toggle
    final ThemeModeEnum themeModeEnum =
        state.themeModeEnum == ThemeModeEnum.dark
        ? ThemeModeEnum.light
        : ThemeModeEnum.dark;

    // 테마 테마모드를 알아내 테마 변경
    final ThemeData themeData = state.themeModeEnum == ThemeModeEnum.dark
        ? AppThemeData.light
        : AppThemeData.dark;

    // 새롭게 설정된 데이터를 상태관리에 업데이트
    emit(state.copyWith(themeModeEnum: themeModeEnum, themeData: themeData));
  }
}
