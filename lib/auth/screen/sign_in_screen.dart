import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:validators/validators.dart';

import '/common/util/global_loading.dart';
import '/common/util/logger.dart';
import '/common/widget/app_text.dart';
import '/common/widget/app_text_form_field.dart';
import '/common/widget/dialog_widget.dart';

// TODO: 다국어 지원 시 수정 필요
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
  Widget _logoTitleWidget() {
    return SvgPicture.asset(
      'assets/svgs/instagram_letter.svg',
      height: 60,
      // TODO: 나중에 테마 기능 작성 시 수정 필요
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    );
  }

  // 이메일 입력 위젯
  Widget _emailInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _emailController,
      labelText: '이메일',
      helperText: '가입할 때 등록한 이메일을 입력해 주세요.',
      iconData: Icons.email,
      validator: (String? value) {
        // 입력을 안했거나, 공백이거나, 이메일 형식이 아니면 유효성 검증 실패
        if (value == null || value.trim().isEmpty || !isEmail(value.trim())) {
          return '이메일 형식이 올바르지 않습니다!';
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
      labelText: '비밀번호',
      helperText: '가입할 때 등록한 비밀번호를 입력해 주세요.',
      iconData: Icons.lock,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '비밀번호가 올바르지 않습니다!';
        }
        if (value.length < 3 || value.length > 10) {
          return '비밀번호는 최소 3글자, 최대 10글자 이하로 입력 가능합니다!';
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
                // 로그인 로직 호출
                // ...
                // Loading 종료
                GlobalLoading.showLoading(false);
                // SnackBar 메시지
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(
                        '${_emailController.text.trim().toString()}님 반갑습니다!',
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
                  title: '로그인 오류',
                  msg: e.toString(),
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const AppText('로그인'),
    );
  }

  // 회원가입 버튼 위젯
  Widget _signUpButtonWidget() {
    return TextButton(
      onPressed: () {},
      child: AppText('회원이 아니신가요? 회원가입하기', fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    _logoTitleWidget(),
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
