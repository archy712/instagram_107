import 'package:flutter/material.dart';
import 'package:instagram_107/common/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 오른쪽 상단 디버그 표시 제거
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
