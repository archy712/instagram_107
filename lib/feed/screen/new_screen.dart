import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '/common/util/global_loading.dart';
import '/common/util/locale/generated/l10n.dart';
import '/common/util/logger.dart';
import '/common/widget/app_text.dart';
import '/common/widget/chewie_widget.dart';
import '/common/widget/dialog_widget.dart';
import '/common/widget/image_slider_widget.dart';
import '/feed/cubit/feed_cubit.dart';
import '/feed/enum/feed_type_enum.dart';
import '/feed/state/feed_state.dart';

class NewScreen extends StatefulWidget {
  // 게시글 업로드 후 실행될 Callback 함수
  final VoidCallback onFeedUploaded;

  const NewScreen({super.key, required this.onFeedUploaded});
  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  // 갤러리에서 사진 여러개 저장할 변수
  final List<String> _pickedMedias = [];
  // 이미지/동영상 선택 구분 (image / video)
  FeedTypeEnum _feedTypeEnum = FeedTypeEnum.image;
  // 피드 내용 핸들링
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    // 메모리 릭 방지
    _captionController.dispose();
    super.dispose();
  }

  // 갤러리에서 동영상 선택
  Future<void> _pickVideo() async {
    // 비디오를 갤러리에서 선택
    final XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    // 내부 상태변수에 로컬 동영상 경로가 저장 되었다면
    if (video != null) {
      setState(() {
        // 이전에 선택된 이미지가 있었다면 초기화
        _pickedMedias.clear();
        // 비디오 로컬 경로 저장
        _pickedMedias.add(video.path);
        // 선택된 타입을 video 타입으로 저장
        _feedTypeEnum = FeedTypeEnum.video;
      });
    } else {
      log('이미지 선택 취소');
    }
  }

  // 갤러리에서 여러개의 이미지 선택
  // 갤러리에서 사진 여러개 선택 후 접근 경로 반환
  Future<void> _pickImages() async {
    // 갤러리에서 이미지 선택. 사진 해상도가 크더라도 최대 1024 사이즈로 축소
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      maxWidth: 1024,
    );
    // XFile 형태의 이미지 경로를 String 형태의 path 정보 변환
    final List<String> pickedImagesPath = pickedImages
        .map((xFile) => xFile.path)
        .toList();
    // 선택한 이미지가 1개 이상이라면
    if (pickedImages.isNotEmpty) {
      setState(() {
        // 비디오를 선택 했었다면 기존 저장 파일들 비우기
        if (_feedTypeEnum == FeedTypeEnum.video) {
          _pickedMedias.clear();
        }
        // 내부 이미지 경로 상태변수에 저장
        _pickedMedias.addAll(pickedImagesPath);
        // 선택된 타입을 video 타입으로 저장
        _feedTypeEnum = FeedTypeEnum.image;
      });
    } else {
      log('이미지 선택 취소');
    }
    // 선택한 이미지 경로 출력
    log(_pickedMedias.toString());
  }

  // 업로드 미디어 타입 ModalBottomSheet
  void _selectUploadMediaType(BuildContext context) {
    // 하단 BottomSheet 에서 이미지 선택 방법
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 사진들 선택
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(S.current.newSelectPhotos),
                onTap: () {
                  _pickImages();
                  Navigator.pop(context);
                },
              ),
              // 동영상 선택 - 릴스
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(S.current.newSelectVideo),
                onTap: () {
                  _pickVideo();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 상단 미디어 (이미지/동영상) 보여주는 위젯
  Widget _mediaHeaderWidget() {
    return Container(
      height: _pickedMedias.isEmpty ? MediaQuery.of(context).size.width : null,
      width: double.infinity,
      color: Colors.grey[300],
      child: _pickedMedias.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 100, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    S.current.newSelectMediaText,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : _feedTypeEnum == FeedTypeEnum.image
          // 이미지 슬라이드 위젯 표시
          ? ImageSliderWidget(images: _pickedMedias, isNewScreen: true)
          // 비디오 위젯 표시
          : ChewieWidget(videoUrl: _pickedMedias[0], isNewScreen: true),
    );
  }

  // 피드 내용 위젯
  Widget _feedCaptionWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 클립 아이콘 (미디어 선택)
        IconButton(
          icon: const Icon(Icons.attach_file, color: Colors.grey, size: 30),
          onPressed: () {
            // 미디어 타입 선택
            _selectUploadMediaType(context);
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _captionController,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
              hintText: S.current.newFeedHintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // 피드 업로드
  Future<void> _feedUpload(BuildContext context) async {
    try {
      // 포커스 내리고
      FocusScope.of(context).unfocus();
      // 로딩 시작
      GlobalLoading.showLoading(true);
      // 피드 업로드
      await context.read<FeedCubit>().uploadFeed(
        feedMedias: _pickedMedias,
        feedContent: _captionController.text,
        feedTypeEnum: _feedTypeEnum,
      );
      // 로딩 종료
      GlobalLoading.showLoading(false);
      // SnackBar 메시지 표시
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
              S.current.newFeedUploadSuccess,
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 10),
          ),
        );
      }
      // 업로드 수행 후 전송된 함수 실행
      widget.onFeedUploaded();
    } catch (e, stackTrace) {
      // 로딩 종료
      GlobalLoading.showLoading(false);
      logger.e(stackTrace.toString());
      DialogWidget.showAlertDialog(
        title: S.current.newFeedErrorTitle,
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 피드 업로드 상태
    final FeedStatusEnum feedStatusEnum = context
        .watch<FeedCubit>()
        .state
        .feedStatusEnum;

    return Scaffold(
      appBar: AppBar(
        // leading 속성을 사용하여 기본 뒤로 가기 버튼을 대체
        // 클릭하면 홈 화면인 피드 화면으로 분기
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: widget.onFeedUploaded,
        ),
        title: Text(S.current.newFeedTitleText),
        centerTitle: true,
        actions: [
          TextButton(
            // 피드 올리는 중이라면 [피드 업로드] 버튼 비활성화
            onPressed: feedStatusEnum == FeedStatusEnum.submitting
                ? null
                : () {
                    // 피드 올리기
                    _feedUpload(context);
                  },
            child: Text(
              S.current.newFeedUploadText,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 업로드 중 막대 애니메이션 표시
            LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              // null 이면 움직이고, null 아니면 움직이지 않음
              value: feedStatusEnum == FeedStatusEnum.submitting ? null : 1,
              color: feedStatusEnum == FeedStatusEnum.submitting
                  ? Colors.red
                  : Colors.transparent,
            ),
            GestureDetector(
              onTap: () {
                // 미디어 타입 선택
                _selectUploadMediaType(context);
              },
              child: _mediaHeaderWidget(),
            ),
            // 스토리 캡션 입력
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _feedCaptionWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
