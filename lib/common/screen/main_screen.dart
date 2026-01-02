import 'package:flutter/material.dart';
import 'package:instagram_107/common/widget/app_text.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppText('AppText 컴포넌트 활용')));
  }
}
