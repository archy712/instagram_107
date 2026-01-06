import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validators/validators.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/screen/sign_in_screen.dart';
import '/common/cubit/custom_theme_cubit.dart';
import '/common/state/custom_theme_state.dart';
import '/common/util/global_loading.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/app_text.dart';
import '/common/widget/app_text_form_field.dart';
import '/common/widget/dialog_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 갤러리에서 사진 선택 후 저장할 상태 변수
  File? _profileImage;

  // Form 유효성 검증을 위한 Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 각 TextFormField 값 확인을 위한 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form 위젯의 AutoValidateMode 속성
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // 버튼 비활성화 여부
  bool _isEnabled = true;

  @override
  void dispose() {
    // 메모리 누수 방지
    _emailController.dispose();
    _nameController.dispose();
    _commentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 갤러리에서 사진 선택 후 사진 가져오기
  Future<void> _selectProfileImage() async {
    // 갤러리 띄우기 (사이즈가 클 경우 최대 512로 줄임)
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    // 이미지를 선택했다면, 상태 변수에 저장
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
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

  // 프로필 이미지 위젯
  Widget _profileImageWidget() {
    // 실제 필요한 만큼만 공간 차지하기 위해 Container 감싸기
    return Container(
      alignment: Alignment.center,
      // Stack : 가로 길이만큼 너비 차지
      child: Stack(
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 64,
            backgroundImage: _profileImage == null
                ? AssetImage('assets/images/profile.png')
                : FileImage(_profileImage!),
          ),
          // 카메라 아이콘
          Positioned(
            // 왼쪽에서 오른쪽으로 80 만큼 이동
            left: 80,
            // 아래에서 위로 10만큼
            bottom: -10,
            child: IconButton(
              onPressed: _isEnabled ? _selectProfileImage : null,
              icon: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }

  // 이메일 입력 위젯
  Widget _emailInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _emailController,
      labelText: S.current.signUpEmailText,
      iconData: Icons.email,
      helperText: S.current.signUpHelperEmailText,
      validator: (String? value) {
        // 입력을 안했거나, 공백이거나, 이메일 형식이 아니면 유효성 검증 실패
        if (value == null || value.trim().isEmpty || !isEmail(value.trim())) {
          return S.current.signUpValidatorEmailText1;
        }
        // 이메일 유효성 검증이 통과하면 성공 => null 리턴
        return null;
      },
    );
  }

  // 이름 입력 위젯
  Widget _nameInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _nameController,
      labelText: S.current.signUpNameText,
      iconData: Icons.account_circle,
      helperText: S.current.signUpHelperNameText,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.signUpValidatorNameText1;
        }
        if (value.length < 3 || value.length > 10) {
          return S.current.signUpValidatorNameText2;
        }
        return null;
      },
    );
  }

  // 한줄 소개 위젯
  Widget _commentInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _commentController,
      labelText: S.current.signUpCommentText,
      iconData: Icons.comment,
      helperText: S.current.signUpHelperCommentText,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.signUpValidatorCommentText1;
        }
        if (value.length < 5 || value.length > 20) {
          return S.current.signUpValidatorCommentText2;
        }
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
      labelText: S.current.signUpPasswordText,
      helperText: S.current.signUpHelperPasswordText,
      iconData: Icons.lock,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.signUpValidatorPasswordText1;
        }
        if (value.length < 3 || value.length > 10) {
          return S.current.signUpValidatorPasswordText2;
        }
        return null;
      },
    );
  }

  // 비밀번호 확인 입력 위젯
  Widget _passwordConfirmInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      obscureText: true,
      labelText: S.current.signUpPasswordConfirmText,
      helperText: S.current.signUpHelperPasswordConfirmText,
      iconData: Icons.lock_clock_rounded,
      validator: (String? value) {
        if (value != _passwordController.text) {
          return S.current.signUpValidatorPasswordText3;
        }
        return null;
      },
    );
  }

  // 회원가입 버튼 위젯
  Widget _signUpButtonWidget() {
    return ElevatedButton(
      onPressed: _isEnabled
          ? () async {
              // 키보드 내리고
              FocusScope.of(context).unfocus();

              // 유효성 검증을 위한 FormState 얻기
              final FormState? formState = _formKey.currentState;

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

                // 회원가입 로직 호출
                await context.read<AuthCubit>().signUpWithEmailAndPassword(
                  email: _emailController.text,
                  name: _nameController.text,
                  comment: _commentController.text,
                  password: _passwordController.text,
                  profileImage: _profileImage,
                );

                // SnackBar 메시지
                if (mounted) {
                  // 가입 후에는 로그인 화면으로 이동
                  // 화면이동 + 메시지 표시 작업이 동시에 이루어 질 때 화면이동을 먼저.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(
                        S.current.signUpSendVerificationEmailText2,
                        textAlign: TextAlign.center,
                        color: Colors.black,
                      ),
                      duration: Duration(seconds: 10),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }

                // 로딩 종료
                GlobalLoading.showLoading(false);
              } on FirebaseAuthException catch (e) {
                // 로딩 종료
                GlobalLoading.showLoading(false);

                // 오류 발생하면 모든 항목 활성화
                setState(() {
                  _isEnabled = true;
                });
                // FirebaseAuthException에 따른 오류 메시지 분기 처리
                String errorMessage;
                switch (e.code) {
                  case 'weak-password':
                    errorMessage = S.current.signUpWeakPasswordErrorMsg;
                    break;
                  case 'email-already-in-use':
                    errorMessage = S.current.signUpEmailAlreadyInUseErrorMsg;
                    break;
                  case 'invalid-email':
                    errorMessage = S.current.signUpInvalidEmailErrorMsg;
                    break;
                  default:
                    errorMessage = S.current.signUpDefaultErrorMsg;
                    break;
                }
                // Dialog Box
                DialogWidget.showAlertDialog(
                  title: S.current.signUpErrorTitle,
                  msg: errorMessage,
                );
              } catch (e, stackTrace) {
                // 로딩 종료
                GlobalLoading.showLoading(false);

                // 오류 발생하면 모든 항목 활성화
                setState(() {
                  _isEnabled = true;
                });
                // 커맨드창에 상세 오류 표시
                logger.e(stackTrace.toString());
                // Dialog Box
                DialogWidget.showAlertDialog(
                  title: S.current.signUpErrorTitle,
                  msg: e.toString(),
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: AppText(S.current.signUpButtonText),
    );
  }

  // 로그인 버튼 위젯
  Widget _signInInButtonWidget() {
    return TextButton(
      onPressed: _isEnabled
          ? () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            }
          : null,

      child: AppText(S.current.signUpLoginLinkText, fontSize: 14),
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
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  // 원래 위아래 전체 길이인데, 필요한 만큼만 차지하게 (정중앙 정렬)
                  shrinkWrap: true,
                  // 키보드 올라온 만큼 위젯 가려지지 않게 위로 올리기
                  // ListView : reverse 속성 true + children [].reversed.toList()
                  reverse: true,
                  children: [
                    const SizedBox(height: 20),
                    // 로고 타이틀 위젯
                    _logoTitleWidget(themeModeEnum: themeModeEnum),
                    const SizedBox(height: 40),
                    // 프로필 이미지 위젯
                    _profileImageWidget(),
                    const SizedBox(height: 40),
                    // 이메일 입력 위젯
                    _emailInputWidget(),
                    const SizedBox(height: 20),
                    // 이름 입력 위젯
                    _nameInputWidget(),
                    const SizedBox(height: 20),
                    // 한줄 소개 입력 위젯
                    _commentInputWidget(),
                    const SizedBox(height: 20),
                    // 비밀번호 입력 위젯
                    _passwordInputWidget(),
                    const SizedBox(height: 20),
                    // 비밀번호 확인 입력 위젯
                    _passwordConfirmInputWidget(),
                    const SizedBox(height: 40),
                    // 회원가입 버튼 위젯
                    _signUpButtonWidget(),
                    const SizedBox(height: 20),
                    // 로그인 버튼 위젯
                    _signInInButtonWidget(),
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
