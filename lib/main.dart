import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '/auth/screen/sign_up_screen.dart';
import 'firebase_options.dart';

void main() async {
  // main 함수에서 Native 기능 사용을 위해 앱이 초기화 될 때까지 기다림
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 오른쪽 상단 디버그 표시 제거
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
