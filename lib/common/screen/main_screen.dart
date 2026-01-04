import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/common/util/logger.dart';
import '/common/widget/dialog_widget.dart';
import '/feed/screen/feed_screen.dart';
import '/feed/screen/new_screen.dart';
import '/feed/screen/reels_screen.dart';
import '/profile/screen/profile_screen.dart';
import '/search/screen/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // BottomNavigationBar 연동되는 화면 인덱스
  int _selectedItemIndex = 0;

  // PageView 제어하기 위한 컨트롤러
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // 현재 접속자 정보를 상태관리 데이터로 저장
    _getCurrentUser();

    // 컨트롤러 초기화
    _pageController = PageController();
  }

  @override
  void dispose() {
    // 메모리 누수 방지
    _pageController.dispose();
    super.dispose();
  }

  // 하단 BottomNavigationBar 눌렀을 때 실행
  void _onItemTapped(int index) {
    // 화면 인덱스를 필드변수에 저장
    setState(() {
      _selectedItemIndex = index;
    });
    // 선택된 인덱스로 PageView 이동
    _pageController.jumpToPage(index);
  }

  // 현재 접속자 정보를 상태관리 데이터로 저장
  // TODO : 나중에 다국어 지원 시 변경
  Future<void> _getCurrentUser() async {
    try {
      await context.read<UserCubit>().getCurrentUser();
    } catch (e, stackTrace) {
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(title: '회원정보 로드 오류', msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          // 사용자가 swipe 했을 때 BottomNavigationBar 업데이트
          setState(() {
            _selectedItemIndex = index;
          });
        },
        children: const <Widget>[
          // 피드 리스트
          FeedScreen(),
          // 검색
          SearchScreen(),
          // 새 피드
          NewScreen(),
          // 릴스
          ReelsScreen(),
          // 프로필
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // TODO: 임시로 선택/비선택 색상 선정 (나중에 테마 부분에서 변경 예정)
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedItemIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_outlined),
            label: '등록',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            label: '릴스',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
