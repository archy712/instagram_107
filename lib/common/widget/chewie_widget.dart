import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieWidget extends StatefulWidget {
  // 동영상 URL
  final String videoUrl;
  // 등록 화면에서 사용 여부 (로컬 동영상)
  final bool isNewScreen;
  // 프로필 화면에서 사용 여부
  final bool isProfileScreen;

  // 생성자
  const ChewieWidget({
    super.key,
    required this.videoUrl,
    this.isNewScreen = false,
    this.isProfileScreen = false,
  });

  @override
  State<ChewieWidget> createState() => _ChewieWidgetState();
}

class _ChewieWidgetState extends State<ChewieWidget> {
  // VideoPlayer 컨트롤러
  late VideoPlayerController _videoPlayerController;
  // Chewie 컨트롤러
  ChewieController? _chewieController;
  // 컨트롤러 초기화 상태 (Chewie 컨트롤러 초기화 여부)
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 동영상 플레이어 초기화
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant ChewieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // videoUrl이 변경되었을 경우에 컨트롤러 다시 초기화
    if (widget.videoUrl != oldWidget.videoUrl) {
      // 기존 Chewie 컨트롤러 해제
      _chewieController?.dispose();
      // 기존 VideoPlayer 컨트롤러 해제
      _videoPlayerController.dispose();
      // 새로운 URL 사용하여 컨트롤러 다시 초기화
      _initializeVideoPlayer();
    }
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위한 자원 해제
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // VideoPlayerController, ChewieController 초기화
  void _initializeVideoPlayer() async {
    _videoPlayerController =
        (widget.isNewScreen
              // 등록 모드일 때는 로컬 경로를 사용
              ? VideoPlayerController.file(File(widget.videoUrl))
              // 피드 모드일 때는 업로드 된 원격 경로를 사용
              : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)))
          ..initialize()
              .then((_) {
                // 초기에는 음소거
                // ChewieController는 VideoPlayerController의 볼륨 설정 따름
                // Chewie가 볼륨 컨트롤을 제공하므로 여기서 직접 설정할 필요는 없지만,
                // 초기 상태를 위해 설정 가능
                _videoPlayerController.setVolume(0.0);
                // VideoPlayerController 초기화 성공 후 ChewieController 초기화
                _initializeChewieController();
                setState(() {
                  // 초기화 완료
                  _isInitialized = true;
                });
              })
              .catchError((error) {
                log('Error initializing video player: $error');
                setState(() {
                  _isInitialized = false;
                });
              });
  }

  // ChewieController 초기화
  void _initializeChewieController() {
    // VideoPlayerController 초기화 성공 후 ChewieController 초기화
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      // 비디오의 원본 비율 사용
      aspectRatio: _videoPlayerController.value.aspectRatio,
      // 자동 재생
      autoPlay: true,
      // 반복 재생
      looping: true,
      // 기본 컨트롤 표시
      showControls: true,
      // 로딩 위젯 커스터마이징
      placeholder: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      // Chewie가 자동으로 VideoPlayerController 초기화 하도록 설정
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        // 에러 발생 시 표시할 위젯
        return Center(
          child: Text(
            '동영상 재생 오류: $errorMessage',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  // 등록 모드일 때 위젯
  Widget _newModeWidget() {
    return Container(
      // 등록 모드일 때 너비와 높이 고정
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.65,
      // 비디오가 없는 부분의 배경색
      color: Colors.grey[100],
      child: FittedBox(
        // 비디오를 컨테이너 안에 맞춤 (원본 비율 유지)
        fit: BoxFit.contain,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }

  // 피드 모드일 때 위젯
  Widget _feedModeWidget() {
    return AspectRatio(
      // 피드 목록 모드일 때 비디오의 원본 비율 유지
      aspectRatio:
          _chewieController!.aspectRatio ??
          _videoPlayerController.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }

  // 프로필 화면에서의 위젯
  Widget _profileScreenWidget() {
    // 가로가 긴 동영상의 경우 위아래 불필요한 공간이 없어지도록 개선된 버전
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return AspectRatio(
        // 피드 목록 모드일 때 비디오의 원본 비율 유지
        aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
        // `FittedBox`로 `Chewie` 위젯을 감싸서 오버플로우 방지
        child: FittedBox(
          fit: BoxFit.cover, // 동영상이 잘리지 않고 부모 위젯을 채우도록 설정
          child: SizedBox(
            // Chewie 위젯이 들어갈 공간을 동영상 원본 비율에 맞게 설정
            width: _chewieController!.videoPlayerController.value.size.width,
            height: _chewieController!.videoPlayerController.value.size.height,
            child: Chewie(controller: _chewieController!),
          ),
        ),
      );
    } else {
      // 컨트롤러가 초기화되지 않았을 때 로딩 인디케이터 표시
      return Container(
        color: Colors.grey[100],
        child: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  // 로딩 시 보여줄 위젯
  Widget _loadingWidget() {
    return Container(
      // 로딩 중일 때 표시
      height: widget.isNewScreen
          // 등록 모드일 때
          ? MediaQuery.of(context).size.height * 0.65
          // 피드 모드일 때
          : MediaQuery.of(context).size.width * (9 / 16),
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isInitialized &&
                _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            // 로딩이 완료 되었다면
            ? widget.isNewScreen
                  // 등록 모드일 때 위젯
                  ? _newModeWidget()
                  // 피드모드일 때 위젯
                  : widget.isProfileScreen
                  // 프로필 화면에서 일 때
                  ? _profileScreenWidget()
                  // 피드 목록일 때
                  : _feedModeWidget()
            // 로딩 위젯
            : _loadingWidget(),
      ],
    );
  }
}
