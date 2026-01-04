import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/screen/sign_in_screen.dart';
import '/auth/state/auth_state.dart';
import '/common/screen/main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 인증 상태값 (AuthCurrentStatus) 값에 따라 분기
    final AuthCurrentStatusEnum authCurrentStatusEnum = context
        .watch<AuthCubit>()
        .state
        .authCurrentStatusEnum;

    // 인증된 상태라면 메인 스크린으로 이동, 인증된 상태가 아니면 로그인 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              authCurrentStatusEnum == AuthCurrentStatusEnum.authenticated
              ? MainScreen()
              : SignInScreen(),
        ),
        // 기존의 화면 위젯들 중 첫번째만 남겨두고 나머지 삭제
        (route) => route.isFirst,
      );
    });

    // 나머지 처리 될 때에는 CircularProgressIndicator() 처리
    return Scaffold(body: Center(child: const CircularProgressIndicator()));
  }
}
