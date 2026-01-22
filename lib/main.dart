import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/cubit/user_cubit.dart';
import '/auth/repository/auth_repository.dart';
import '/auth/repository/user_repository.dart';
import '/common/cubit/custom_theme_cubit.dart';
import '/common/cubit/locale_cubit.dart';
import '/common/screen/splash_screen.dart';
import '/common/state/custom_theme_state.dart';
import '/common/util/locale/generated/l10n.dart';
import '/feed/cubit/feed_cubit.dart';
import '/feed/repository/feed_repository.dart';
import '/profile/cubit/profile_cubit.dart';
import 'firebase_options.dart';
import 'profile/repository/profile_repository.dart';

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
        // 사용자 Repository
        RepositoryProvider(
          create: (context) => UserRepository(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        // 피드 관리 (목록, 업로드)
        RepositoryProvider(
          create: (context) => FeedRepository(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        // 프로필 Repository
        RepositoryProvider(
          create: (context) =>
              ProfileRepository(firebaseFirestore: firebaseFirestore),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // 다국어 Cubit
          BlocProvider(create: (context) => LocaleCubit()),
          // 테마 Cubit
          BlocProvider(create: (context) => CustomThemeCubit()),
          // 사용자 회원가입, 로그인
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
            // 선언과 동시에 실행
            lazy: false,
          ),
          // 사용자 Cubit
          BlocProvider(
            create: (context) =>
                UserCubit(userRepository: context.read<UserRepository>()),
          ),
          // 피드 관리 (업로드, 목록)
          BlocProvider(
            create: (context) => FeedCubit(
              feedRepository: context.read<FeedRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          // 프로필 Cubit
          BlocProvider(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
              feedRepository: context.read<FeedRepository>(),
            ),
          ),
        ],
        child: GlobalLoaderOverlay(
          overlayColor: const Color.fromRGBO(0, 0, 0, 0.4),
          overlayWidgetBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
          child: BlocBuilder<CustomThemeCubit, CustomThemeState>(
            builder: (context, state) {
              // 화면 테마
              final ThemeData themeData = state.themeData;

              // Locale 설정을 위한 BlocBuilder
              return BlocBuilder<LocaleCubit, Locale>(
                builder: (context, state) {
                  // 언어 Locale
                  final Locale locale = state;
                  return MaterialApp(
                    // Locale 설정
                    locale: locale,
                    // 현지화
                    localizationsDelegates: const [
                      S.delegate,
                      // 텍스트 현지화
                      GlobalMaterialLocalizations.delegate,
                      // 위젯 현지화
                      GlobalWidgetsLocalizations.delegate,
                      // iOS 현지화 (지정 안하면 경고 메시지 계속 발생)
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    // 지원되는 현지화 목록에 대한 정보 전달 (한국, 미국 등)
                    supportedLocales: S.delegate.supportedLocales,
                    navigatorKey: navigatorKey,
                    // 오른쪽 상단 디버그 표시 제거
                    debugShowCheckedModeBanner: false,
                    theme: themeData,
                    home: SplashScreen(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
