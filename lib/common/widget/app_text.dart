import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  // 보여줄 텍스트
  final String text;
  // 폰트 사이즈
  final double? fontSize;
  // 폰트 굵기
  final FontWeight? fontWeight;
  // 폰트 컬러
  final Color? color;
  // 텍스트 정렬 위치
  final TextAlign? textAlign;
  // 라인 수
  final int? maxLines;
  // 글자수 많을때 처리 방법
  final TextOverflow? overflow;
  // 라인 높이
  final double? height;

  const AppText(
    this.text, {
    this.textAlign = TextAlign.left,
    this.fontSize = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.notoSans(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
