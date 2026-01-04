import 'package:flutter/material.dart';

class AppThemeData {
  // light 테마
  static ThemeData light = ThemeData(
    // ColorScheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.light,
      // 주요 색상 검정
      primary: Colors.black,
      // 검정색 위 글자색 흰색
      onPrimary: Colors.white,
      // 강조색으로 사용될 수 있는 어두운 회색
      secondary: Colors.grey[800]!,
      onSecondary: Colors.white,
      // 배경색 흰색
      surface: Colors.white,
      // 흰색 위 글자색 검정
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      // 테두리 색상
      outline: Colors.grey[300],
      // 카드 배경 등
      surfaceContainerHighest: Colors.grey[100],
    ),
    // AppBar
    appBarTheme: const AppBarTheme(
      // 앱바 배경 흰색
      backgroundColor: Colors.white,
      // 앱바 아이콘/글자 검정
      foregroundColor: Colors.black,
      // 그림자 없음
      elevation: 0,
      // 제목 왼쪽 정렬
      centerTitle: false,
      // Material3 AppBar 색상 변경 방지
      surfaceTintColor: Colors.white,
    ),
    // Scaffold 배경 흰색
    scaffoldBackgroundColor: Colors.white,
    // TextTheme
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 15),
      bodySmall: TextStyle(color: Colors.grey[700], fontSize: 14),
      titleLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleSmall: TextStyle(color: Colors.grey[800], fontSize: 14),
    ),
    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // 일반 텍스트 버튼 색상
        foregroundColor: Colors.grey[700],
      ),
    ),
    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    // BottomNavigationBar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black54,
      unselectedItemColor: Colors.grey[400],
      // 아이템 수에 따라 고정
      type: BottomNavigationBarType.fixed,
      // 라벨 숨김
      showSelectedLabels: true,
      showUnselectedLabels: false,
      // 그림자 없음
      elevation: 0,
    ),
    // TabBar
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey[500],
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: Colors.black26),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  // dark 테마
  static ThemeData dark = ThemeData(
    // ColorScheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
      // 주요 색상 검정
      primary: Colors.white,
      // 검정색 위 글자색 검정
      onPrimary: Colors.black,
      // 강조색으로 사용될 수 있는 밝은 회색
      secondary: Colors.grey[400]!,
      onSecondary: Colors.black,
      // 배경색 흰색
      surface: Colors.black,
      // 흰색 위 글자색 흰색
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.black,
      // 테두리 색상
      outline: Colors.grey[600],
      // 카드 배경 등
      surfaceContainerHighest: Colors.grey[800],
    ),
    // AppBar
    appBarTheme: const AppBarTheme(
      // 앱바 배경 검정
      backgroundColor: Colors.black,
      // 앱바 아이콘/글자 흰색
      foregroundColor: Colors.white,
      // 그림자 없음
      elevation: 0,
      // 제목 왼쪽 정렬
      centerTitle: false,
      // Material3 AppBar 색상 변경 방지
      surfaceTintColor: Colors.black,
    ),
    // Scaffold 배경 검정
    scaffoldBackgroundColor: Colors.black,
    // TextTheme
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
      bodySmall: TextStyle(color: Colors.grey[300], fontSize: 14),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleSmall: TextStyle(color: Colors.grey[300], fontSize: 14),
    ),
    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // 일반 텍스트 버튼 색상
        foregroundColor: Colors.grey[300],
      ),
    ),
    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.grey[800]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[500],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    // BottomNavigationBar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black54,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[700],
      // 아이템 수에 따라 고정
      type: BottomNavigationBarType.fixed,
      // 라벨 숨김
      showSelectedLabels: true,
      showUnselectedLabels: false,
      // 그림자 없음
      elevation: 0,
    ),
    // TabBar
    tabBarTheme: TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey[500],
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: Colors.white),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
