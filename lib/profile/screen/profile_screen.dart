import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/auth/state/user_state.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/dialog_widget.dart';
import '/feed/model/feed_model.dart';
import '/profile/cubit/profile_cubit.dart';
import '/profile/state/profile_state.dart';
import '/profile/widget/profile_app_bar_widget.dart';
import '/profile/widget/profile_body_widget.dart';
import '/profile/widget/profile_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ProfileCubit 변수 선언
  late final ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    // Cubit 초기화
    profileCubit = context.read<ProfileCubit>();
    // 화면이 생성되면서 프로필 정보를 상태관리 업데이트
    _getProfile();
  }

  // 프로필 정보를 상태관리 업데이트
  void _getProfile() {
    // 위젯을 만들고 난 다음 비동기로 수행
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // UserCubit 에서 사용자 상태관리 정보는 로그인 후 생성
        final String uid = context.read<UserCubit>().state.userModel.uid;
        // ProfileCubit 상태관리 정보 업데이트
        await profileCubit.getProfile(uid: uid);
      } catch (e, stackTrace) {
        logger.e(stackTrace.toString());
        DialogWidget.showAlertDialog(
          title: S.current.profileStateError,
          msg: e.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 사용자 상태관리 정보
    final UserState userState = context.watch<UserCubit>().state;

    // 현재 프로필의 상태관리 정보
    final ProfileState profileState = context.watch<ProfileCubit>().state;

    // 프로필 상태관리 데이터 중 피드 리스트
    final List<FeedModel> feedList = profileState.feedList;

    // 프로필 상태관리 데이터 중 좋아요 리스트
    final List<FeedModel> likeFeedList = profileState.likeFeedList;

    // 프로필 상태관리 데이터 중 북마크 리스트
    final List<FeedModel> bookmarkFeedList = profileState.bookmarkFeedList;

    return Scaffold(
      // --- AppBar ---
      appBar: ProfileAppBarWidget(userModel: userState.userModel),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 프로필 헤더 ---
            ProfileHeaderWidget(userModel: userState.userModel),
            // --- 디바이더 ---
            const Divider(color: Colors.grey),
            // --- 프로필 바디 ---
            ProfileBodyWidget(
              feedList: feedList,
              likeFeedList: likeFeedList,
              bookmarkFeedList: bookmarkFeedList,
            ),
          ],
        ),
      ),
    );
  }
}
