import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/common/widget/app_text.dart';
import '/profile/widget/profile_app_bar_sheet.dart';

// TODO: 다국어 지원 시 수정 필요
class ProfileAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileAppBarWidget({super.key});
  @override
  // kToolbarHeight: 기본 AppBar 높이
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading 아이콘 제거 : 3가지 방법 중 하나
      // Container(), SizedBox.shrink()
      automaticallyImplyLeading: false,
      title: AppText(
        context.read<UserCubit>().state.userModel.name,
        fontSize: 20,
      ),
      actions: [
        IconButton(icon: const Icon(Icons.add_box_outlined), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _showSettingsBottomSheet(context);
          },
        ),
      ],
    );
  }

  // 오른쪽에서 왼쪽으로 나오는 BottomSheet
  // showGeneralDialog + PageRouteBuilder 조합하여 커스텀 애니메이션 구현
  void _showSettingsBottomSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      // 외부 탭 시 닫힘 여부
      barrierDismissible: true,
      // 접근성 레이블
      barrierLabel: 'SettingsBottomSheet',
      // 배경 오버레이 색상
      barrierColor: Colors.black54,
      // 전환 애니메이션 시간
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        // 다이얼로그 내용과 위치를 정의
        return ProfileAppBarSheet();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // 슬라이드 애니메이션을 적용.
        const begin = Offset(1.0, 0.0); // 오른쪽에서 시작 (x=1.0)
        const end = Offset(0.0, 0.0); // 왼쪽으로 끝 (x=0.0)
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
