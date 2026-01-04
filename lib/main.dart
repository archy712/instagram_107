import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/repository/auth_repository.dart';
import '/auth/screen/sign_up_screen.dart';
import 'firebase_options.dart';

// showDialog() 함수를 화면 어디에서나 사용하기 위해 GlobalKey<NavigatorState> 객체 선언
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    // Firebase 관련 인스턴스 변수들
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    return MultiRepositoryProvider(
      providers: [
        // 사용자 회원가입, 로그인
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // 사용자 회원가입, 로그인
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: GlobalLoaderOverlay(
          overlayColor: const Color.fromRGBO(0, 0, 0, 0.4),
          overlayWidgetBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            // 오른쪽 상단 디버그 표시 제거
            debugShowCheckedModeBanner: false,
            home: SignUpScreen(),
          ),
        ),
      ),
    );
  }
}
