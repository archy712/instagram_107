import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  // 동영상 URL
  final String videoUrl;
  // 등록 화면에서 사용 여부 (로컬 동영상)
  final bool isNewScreen;

  // 생성자
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.isNewScreen = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // 비디오 플레이어 컨트롤러
  late VideoPlayerController _videoPlayerController;
  // 동영상 재생 여부
  bool _isPlaying = false;
  // 컨트롤러 초기화 상태
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 동영상 플레이어 초기화
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // videoUrl이 변경되었을 경우에 컨트롤러 다시 초기화
    if (widget.videoUrl != oldWidget.videoUrl) {
      // 기존 컨트롤러 해제
      _videoPlayerController.dispose();
      // 새로운 URL 사용하여 컨트롤러 다시 초기화
      _initializeVideoPlayer();
    }
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위한 자원 해제
    _videoPlayerController.dispose();
    super.dispose();
  }

  // 동영상 플레이어 초기화 (현재는 1개 동영상만)
  void _initializeVideoPlayer() {
    _videoPlayerController =
        (widget.isNewScreen
              // 로컬 동영상 선택 (등록 모드)
              ? VideoPlayerController.file(File(widget.videoUrl))
              // 원격 동영상 선택
              : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)))
          ..initialize()
              .then((_) {
                setState(() {
                  _isInitialized = true;
                });
                // 반복 재생
                _videoPlayerController.setLooping(true);
                // 초기에는 음소거
                _videoPlayerController.setVolume(0.0);
                // 자동 재생
                _videoPlayerController.play();
              })
              .catchError((error) {
                log('Error initializing video player: $error');
                setState(() {
                  // 초기화 실패 시 상태 업데이트
                  _isInitialized = false;
                });
              });
  }

  // 등록 모드일 때 위젯 (로컬 파일)
  Widget _newModeWidget() {
    return Container(
      // 너비 고정
      width: MediaQuery.of(context).size.width,
      // 높이 고정
      height: MediaQuery.of(context).size.height * 0.65,
      // 비디오가 없는 부분의 배경색
      color: Colors.grey[100],
      child: FittedBox(
        // 비디오를 컨테이너 안에 맞춤 (원본 비율 유지)
        fit: BoxFit.contain,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: VideoPlayer(_videoPlayerController),
        ),
      ),
    );
  }

  // 피드 목록 모드일 때 위젯 (원격 인터넷 파일)
  Widget _feedModeWidget() {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: VideoPlayer(_videoPlayerController),
    );
  }

  // 로딩중일 때 표시
  Widget _loadingWidget() {
    return Container(
      height: MediaQuery.of(context).size.width,
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
        // 동영상 재생 영역
        GestureDetector(
          onTap: () {
            // 탭 시 재생/일시정지 토글 및 음소거 해제
            setState(() {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
                _isPlaying = false;
              } else {
                _videoPlayerController.play();
                _isPlaying = true;
                // 재생 시 음소거 해제
                _videoPlayerController.setVolume(1.0);
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isInitialized
                  ? widget.isNewScreen
                        // 등록 모드일 때에는 사이즈 제한
                        ? _newModeWidget()
                        // 피드 목록에서는 실제 사이즈로
                        : _feedModeWidget()
                  : _loadingWidget(),
              // 재생 중이 아니면 플레이 아이콘 표시
              if (!_isPlaying && _isInitialized)
                const Icon(Icons.play_arrow, size: 80, color: Colors.white70),
            ],
          ),
        ),
      ],
    );
  }
}
