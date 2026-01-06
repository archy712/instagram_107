import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/auth_cubit.dart';
import '/common/cubit/custom_theme_cubit.dart';
import '/common/cubit/locale_cubit.dart';
import '/common/state/custom_theme_state.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/widget/app_text.dart';

class ProfileAppBarSheet extends StatelessWidget {
  const ProfileAppBarSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // 테마 모드 확인
    final ThemeModeEnum themeModeEnum = context
        .read<CustomThemeCubit>()
        .state
        .themeModeEnum;

    // Locale 설정
    final Locale locale = context.watch<LocaleCubit>().state;

    return SafeArea(
      child: Align(
        // 왼쪽 정렬
        alignment: Alignment.centerLeft,
        child: Material(
          // Material 위젯으로 감싸서 그림자 효과 및 배경색 적용
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Instagram ${S.current.controlText}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                // 구분선
                const Divider(height: 1),
                // 로그아웃
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(S.current.profileLogout),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    await context.read<AuthCubit>().signOut();
                  },
                ),
                const Divider(height: 1),
                // 테마 선택
                SwitchListTile(
                  secondary: const Icon(Icons.brightness_6),
                  title: AppText(S.current.profileThemeTitle),
                  subtitle: AppText(S.current.profileSubTitle),
                  activeThumbColor: Colors.orange,
                  value: themeModeEnum == ThemeModeEnum.light,
                  onChanged: (value) {
                    context.read<CustomThemeCubit>().toggleThemeMode();
                  },
                ),
                const Divider(height: 1),
                // 다국어
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(S.current.profileLanguage),
                ),
                RadioGroup<Locale>(
                  // 공통으로 관리할 그룹 값과 변경 이벤트를 부모에서 정의.
                  groupValue: locale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      context.read<LocaleCubit>().changeLocale(locale: value);
                    }
                  },
                  // 자식 위젯으로 RadioListTile들을 배치.
                  child: Column(
                    children: [
                      RadioListTile(
                        title: AppText(S.current.profileSettingKr),
                        value: Locale('ko'),
                      ),
                      RadioListTile(
                        title: AppText(S.current.profileSettingEn),
                        value: Locale('en'),
                      ),
                      RadioListTile(
                        title: AppText(S.current.profileSettingJa),
                        value: Locale('ja'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
