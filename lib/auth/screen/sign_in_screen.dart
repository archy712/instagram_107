import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:validators/validators.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/screen/sign_up_screen.dart';
import '/common/cubit/custom_theme_cubit.dart';
import '/common/state/custom_theme_state.dart';
import '/common/util/global_loading.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/app_text.dart';
import '/common/widget/app_text_form_field.dart';
import '/common/widget/dialog_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Form 유효성 검증을 위한 key
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  // 각 TextFormField 값 확인을 위한 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form 위젯의 AutoValidateMode 속성
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // 버튼 비활성화 여부
  bool _isEnabled = true;

  @override
  void dispose() {
    // 앱 종료시에 컨트롤러 종료
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로고 이미지 위젯
  Widget _logoTitleWidget({required ThemeModeEnum themeModeEnum}) {
    return SvgPicture.asset(
      'assets/svgs/instagram_letter.svg',
      height: 60,
      colorFilter: ColorFilter.mode(
        themeModeEnum == ThemeModeEnum.dark ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
    );
  }

  // 이메일 입력 위젯
  Widget _emailInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _emailController,
      labelText: S.current.loginEmailText,
      helperText: S.current.signUpHelperEmailText,
      iconData: Icons.email,
      validator: (String? value) {
        // 입력을 안했거나, 공백이거나, 이메일 형식이 아니면 유효성 검증 실패
        if (value == null || value.trim().isEmpty || !isEmail(value.trim())) {
          return S.current.loginValidatorEmailText1;
        }
        // 이메일 유효성 검증이 통과하면 성공 => null 리턴
        return null;
      },
    );
  }

  // 비밀번호 입력 위젯
  Widget _passwordInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _passwordController,
      obscureText: true,
      labelText: S.current.loginPasswordText,
      helperText: S.current.signUpHelperPasswordText,
      iconData: Icons.lock,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.loginValidatorPasswordText1;
        }
        if (value.length < 3 || value.length > 10) {
          return S.current.loginValidatorPasswordText2;
        }
        return null;
      },
    );
  }

  // 로그인 버튼 위젯
  Widget _signInButtonWidget() {
    return ElevatedButton(
      onPressed: _isEnabled
          ? () async {
              // 키보드 내리고
              FocusScope.of(context).unfocus();

              // 유효성 검증을 위한 FormState 얻기
              final FormState? formState = _globalKey.currentState;

              // 각 항목의 유효성 검증 이후에는 자동으로 검증모드 변경
              setState(() {
                _autovalidateMode = AutovalidateMode.always;
              });

              // 유효성 검증
              if (formState == null || !formState.validate()) {
                return;
              }

              // 유효성 통과하면 모든 항목 비활성화
              setState(() {
                _isEnabled = false;
              });

              try {
                // 로딩 시작
                GlobalLoading.showLoading(true);

                // 로그인 전 상태 확인
                logger.d(
                  context.read<AuthCubit>().state.authProgressStatusEnum,
                );
                logger.d(context.read<AuthCubit>().state.authCurrentStatusEnum);

                // 로그인 로직 호출
                // 유효성 검증 성공하여 로그인 로직 실행
                await context.read<AuthCubit>().signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                // Loading 종료
                GlobalLoading.showLoading(false);

                // 로그인 후 상태 확인
                if (mounted) {
                  logger.d(
                    context.read<AuthCubit>().state.authProgressStatusEnum,
                  );
                  logger.d(
                    context.read<AuthCubit>().state.authCurrentStatusEnum,
                  );
                }

                // SnackBar 메시지
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(
                        S.current.loginGreetingText(
                          _emailController.text.trim().toString(),
                        ),
                        textAlign: TextAlign.center,
                        color: Colors.orange,
                      ),
                      duration: Duration(seconds: 10),
                    ),
                  );
                }
              } catch (e, stackTrace) {
                // Loading 종료
                GlobalLoading.showLoading(false);

                // 커맨드창에 상세 오류 표시
                logger.e(stackTrace.toString());

                // Dialog Box
                DialogWidget.showAlertDialog(
                  title: S.current.loginErrorTitle,
                  msg: S.current.loginErrorContent,
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: AppText(S.current.loginButtonText),
    );
  }

  // 회원가입 버튼 위젯
  Widget _signUpButtonWidget() {
    return TextButton(
      onPressed: _isEnabled
          ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            }
          : null,

      child: AppText(S.current.loginSignUpLinkText, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 테마 모드 확인
    final ThemeModeEnum themeModeEnum = context
        .read<CustomThemeCubit>()
        .state
        .themeModeEnum;

    return PopScope(
      // 뒤로가기 (back) 버튼 비활성화
      canPop: false,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  // 원래 위아래 전체 길이인데, 필요한 만큼만 차지하게 => 정중앙 정렬
                  shrinkWrap: true,
                  // 키보드 올라온 만큼 위젯 가려지지 않게 위로 올리기
                  // ListView : reverse 속성 true + children [].reversed.toList()
                  reverse: true,
                  children: [
                    const SizedBox(height: 20),
                    // 로고 타이틀 위젯
                    _logoTitleWidget(themeModeEnum: themeModeEnum),
                    const SizedBox(height: 60),
                    // 이메일 입력 위젯
                    _emailInputWidget(),
                    const SizedBox(height: 20),
                    // 비밀번호 입력 위젯
                    _passwordInputWidget(),
                    const SizedBox(height: 40),
                    // 로그인 버튼 위젯
                    _signInButtonWidget(),
                    const SizedBox(height: 20),
                    // 회원가입 버튼 위젯
                    _signUpButtonWidget(),
                  ].reversed.toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
