import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/common/cubit/custom_theme_cubit.dart';
import '/common/state/custom_theme_state.dart';

class FeedAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const FeedAppBarWidget({super.key});
  @override
  // kToolbarHeight: 기본 AppBar 높이
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // 로고 이미지 위젯
  Widget _logoTitleWidget({required ThemeModeEnum themeModeEnum}) {
    return SvgPicture.asset(
      'assets/svgs/instagram_letter.svg',
      height: 36,
      colorFilter: ColorFilter.mode(
        themeModeEnum == ThemeModeEnum.dark ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 테마 모드 확인
    final ThemeModeEnum themeModeEnum = context
        .read<CustomThemeCubit>()
        .state
        .themeModeEnum;
    return AppBar(
      automaticallyImplyLeading: false,
      title: _logoTitleWidget(themeModeEnum: themeModeEnum),
      actions: [
        IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
      ],
    );
  }
}
