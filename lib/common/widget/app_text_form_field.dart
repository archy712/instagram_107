import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  // 비밀번호 형식 표기 여부
  final bool obscureText;
  // 버튼 활성화 여부
  final bool enabled;
  // 라벨 텍스트
  final String labelText;
  // Helper 텍스트
  final String helperText;
  // 아이콘
  final IconData iconData;
  // 컨트롤러
  final TextEditingController? controller;
  // 유효성 검사
  final FormFieldValidator<String?>? validator;

  // constructor
  const AppTextFormField({
    super.key,
    this.obscureText = false,
    this.enabled = true,
    required this.labelText,
    required this.helperText,
    required this.iconData,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        // 입력필드에 표시되는 텍스트
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        // 입력필드 앞에 표시되는 아이콘
        prefixIcon: Icon(iconData),
        // 입력 필드의 배경을 채울지 여부.
        filled: true,
        // 입력 필드의 배경 색상. [테마로 인해 변경]
        // fillColor: Colors.grey[200],
        // 입력필드 밑에 표시되는 도움말 텍스트
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.grey[400]),
        // 텍스트와 테두리 사이의 패딩.
        // contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        // 로딩 시 입력 필드의 테두리 스타일.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        // 입력 필드가 활성화되었을 때의 테두리 스타일.
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        // 입력 필드가 포커스를 받았을 때의 테두리 스타일
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
        ),
        // 입력 필드에 오류가 있을 때의 테두리 스타일.
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}
