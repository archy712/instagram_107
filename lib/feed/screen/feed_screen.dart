import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/cubit/user_cubit.dart';
import '/auth/model/user_model.dart';
import '/auth/state/user_state.dart';
import '/common/util/global_loading.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/app_text.dart';
import '/common/widget/dialog_widget.dart';
import '/feed/cubit/feed_cubit.dart';
import '/feed/model/feed_model.dart';
import '/feed/state/feed_state.dart';
import '/feed/widget/feed_app_bar_widget.dart';
import '/feed/widget/feed_card_widget.dart';
import '/feed/widget/top_avatar_list_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin<화면클래스> 사용 시 override 필수
  @override
  bool get wantKeepAlive => true;

  // 자주 사용할 변수이기에 변수로 선언
  late final FeedCubit feedCubit;

  @override
  void initState() {
    super.initState();
    // FeedCubit 초기화 + 피드 목록을 상태관리에 저장
    feedCubit = context.read<FeedCubit>();
    // 앱이 실행되면서 초기화 처리
    _initializeFeedList();
  }

  // 최신 피드목록을 조회 후 상태관리에 저장
  Future<void> _getRecentlyFeedList() async {
    try {
      await feedCubit.getRecentlyFeedList(count: 10);
    } catch (e, stackTrace) {
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(
        title: S.current.feedRecentlyListError,
        msg: e.toString(),
      );
    }
  }

  // 피드목록을 조회 후 상태관리에 저장
  Future<void> _getFeedList() async {
    try {
      await feedCubit.getFeedList();
    } catch (e, stackTrace) {
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(
        title: S.current.feedListError,
        msg: e.toString(),
      );
    }
  }

  // 최신 리스트, 전체 피드 리스트 처리
  Future<void> _initializeFeedList() async {
    await _getRecentlyFeedList();
    await _getFeedList();
  }

  @override
  Widget build(BuildContext context) {
    // AutomaticKeepAliveClientMixin<화면클래스> 사용 시 지정 필수
    super.build(context);

    // FeedState 상태관리 데이터
    FeedState feedState = context.watch<FeedCubit>().state;

    // 최신 피드 리스트 받아오기
    List<FeedModel> recentlyFeedList = feedState.recentlyFeedList;

    // 전체 피드 리스트 받아오기
    List<FeedModel> feedList = feedState.feedList;
    // logger.i(feedList);

    // 피드를 가져오는 중이라면 로딩 표시
    if (feedState.feedStatusEnum == FeedStatusEnum.fetching) {
      GlobalLoading.showLoading(true);
    } else {
      GlobalLoading.showLoading(false);
    }

    // 등록된 피드가 하나도 없다면 없다는 안내 메시지 표시
    if (feedState.feedStatusEnum == FeedStatusEnum.success &&
        feedList.isEmpty) {
      return Center(child: AppText(S.current.feedNoFeedList));
    }

    // 현재 접속한 사용자
    UserState userState = context.watch<UserCubit>().state;
    UserModel currentUserModel = userState.userModel;

    return RefreshIndicator(
      onRefresh: () async {
        await _initializeFeedList();
      },
      child: Scaffold(
        appBar: FeedAppBarWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Large Avatar 부분
              TopAvatarListWidget(
                recentlyFeedList: recentlyFeedList,
                currentUserModel: currentUserModel,
              ),
              const Divider(color: Colors.grey, height: 1),
              // 피드 리스트 부분
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedList.length,
                itemBuilder: (context, index) {
                  // 피드 카드
                  return FeedCardWidget(feedModel: feedList[index]);
                },
                separatorBuilder: (context, int index) {
                  return SizedBox(height: 20);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
