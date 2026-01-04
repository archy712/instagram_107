import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/common/theme/app_theme_data.dart';

// 테마 모드 enum
enum ThemeModeEnum { dark, light }

// 테마 상태 클래스
class CustomThemeState extends Equatable {
  // 테마 모드 (dark, light)
  final ThemeModeEnum themeModeEnum;
  // 테마 컬러
  final ThemeData themeData;

  // 생성자
  const CustomThemeState({
    required this.themeModeEnum,
    required this.themeData,
  });

  // factory init() 생성자
  // 현재 기기의 테마모드(dark 모드, light 모드)를 알아내서 앱의 테마를 설정
  factory CustomThemeState.init() {
    // 현재 기기의 밝기모드(Brightness) 확인
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // 알아낸 기기의 테마모드를 앱의 테마모드와 맞춤
    return CustomThemeState(
      themeModeEnum: brightness == Brightness.dark
          ? ThemeModeEnum.dark
          : ThemeModeEnum.light,
      themeData: brightness == Brightness.dark
          ? AppThemeData.dark
          : AppThemeData.light,
    );
  }

  // copyWith() method
  CustomThemeState copyWith({
    ThemeData? themeData,
    ThemeModeEnum? themeModeEnum,
  }) {
    return CustomThemeState(
      themeModeEnum: themeModeEnum ?? this.themeModeEnum,
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  List<Object?> get props => [themeModeEnum, themeData];
}
