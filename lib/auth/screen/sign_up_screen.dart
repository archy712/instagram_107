import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validators/validators.dart';

import '/auth/cubit/auth_cubit.dart';
import '/auth/screen/sign_in_screen.dart';
import '/common/util/global_loading.dart';
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
  Widget _logoTitleWidget() {
    return SvgPicture.asset(
      'assets/svgs/instagram_letter.svg',
      height: 60,
      // TODO : 나중에 테마 기능 작성 시 수정 필요
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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

  /// TODO: 나중에 다국어 지원 시 변경 필요
  // 이메일 입력 위젯
  Widget _emailInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _emailController,
      labelText: '이메일',
      iconData: Icons.email,
      helperText: '이메일 형식에 맞게 입력해 주세요',
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

  // 이름 입력 위젯
  Widget _nameInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      controller: _nameController,
      labelText: '이름',
      iconData: Icons.account_circle,
      helperText: '이름은 최소 3자 이상, 최대 10자 미만으로 입력해 주세요',
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '이름이 올바르지 않습니다!';
        }
        if (value.length < 3 || value.length > 10) {
          return '이름은 최소 3글자, 최대 10글자 이하로 입력 가능합니다!';
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
      labelText: '한 줄 소개',
      iconData: Icons.comment,
      helperText: '한줄 소개는 최소 5글자 이상, 20글지 이하 이어야 합니다.',
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '한줄 소개가 올바르지 않습니다!';
        }
        if (value.length < 5 || value.length > 20) {
          return '한줄 소개는 최소 5글자, 최대 20글자 이하로 입력 가능합니다!';
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
      labelText: '비밀번호',
      helperText: '비밀번호는 최소 8자, 최대 10자 미만으로 입력해 주세요',
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

  // 비밀번호 확인 입력 위젯
  Widget _passwordConfirmInputWidget() {
    return AppTextFormField(
      enabled: _isEnabled,
      obscureText: true,
      labelText: '비밀번호 확인',
      helperText: '입력한 비밀번호를 다시 한번 입력해 주세요',
      iconData: Icons.lock_clock_rounded,
      validator: (String? value) {
        if (value != _passwordController.text) {
          return '비밀번호 확인이 올바르지 않습니다!';
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
                    const SnackBar(
                      content: AppText(
                        '가입 인증메일을 전송했습니다!\n인증메일을 클릭해야 정식 가입됩니다!',
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
                    errorMessage = '비밀번호가 너무 약합니다. 6자리 이상의 비밀번호를 사용해주세요.';
                    break;
                  case 'email-already-in-use':
                    errorMessage = '이미 사용 중인 이메일 주소입니다. 다른 이메일로 시도해주세요.';
                    break;
                  case 'invalid-email':
                    errorMessage = '유효하지 않은 이메일 주소 형식입니다. 올바른 이메일 주소를 입력해주세요.';
                    break;
                  default:
                    errorMessage = '알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                    break;
                }
                // Dialog Box
                DialogWidget.showAlertDialog(
                  title: '회원가입 오류',
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
                  title: '회원가입 오류',
                  msg: e.toString(),
                );
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const AppText('회원가입'),
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

      child: AppText('이미 회원이신가요? 로그인하기', fontSize: 14),
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
                    _logoTitleWidget(),
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
