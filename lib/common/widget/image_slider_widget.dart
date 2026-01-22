import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/feed/cubit/feed_cubit.dart';
import '/feed/state/feed_state.dart';

class ImageSliderWidget extends StatefulWidget {
  // 이미지 리스트 경로
  final List<String> images;

  // 등록 모드인지 여부
  // Image.file() 사용, 오른쪽 상단에 삭제 기능
  final bool isNewScreen;

  // assets 모드인지 여부
  // Image.asset() 사용
  final bool isAsset;

  // 프로필 화면에서 사용 여부 : 이미지 확대를 하는 기능을 제공
  final bool isProfileScreen;

  const ImageSliderWidget({
    super.key,
    required this.images,
    this.isNewScreen = false,
    this.isAsset = false,
    this.isProfileScreen = false,
  });

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  // 슬라이드에서 현재 보여지는 인덱스
  int showedIndex = 0;

  // 이미지 확대/축소 기능을 위한 함수
  Widget _imageZoomInOutWidget(String imageUrl) {
    return GestureDetector(
      onTap: () => showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return InteractiveViewer(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: _imageWidget(imageUrl),
            ),
          );
        },
      ),

      child: _imageWidget(imageUrl),
    );
  }

  // 이미지를 보여주는 함수
  Widget _imageWidget(String imageUrl) {
    return widget.isNewScreen
        // 1> 로컬 경로 이미지 -> Image.file()
        ? Image.file(
            File(imageUrl),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : widget.isAsset
        // 2> Asset 이미지 -> Image.asset()
        ? Image.asset(imageUrl)
        // 원격 경로 이미지 -> Image.network()
        // 3> Image.network 사용
        // : Image.network(
        //     imageUrl,
        //     width: double.infinity,
        //     height: double.infinity,
        //     fit: BoxFit.cover,
        //   );
        // 3-2> CachedNetworkImage 사용
        // : CachedNetworkImage(
        //     imageUrl: imageUrl,
        //     width: double.infinity,
        //     height: double.infinity,
        //     fit: BoxFit.cover,
        //   );
        // 3-3> ExtendedImage 사용
        : ExtendedImage.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    // 피드 업로드 상태
    final FeedStatusEnum feedStatusEnum = context
        .watch<FeedCubit>()
        .state
        .feedStatusEnum;

    return SizedBox(
      child: Stack(
        children: [
          // 1> CarouselSlider
          CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
              initialPage: showedIndex,
              // 이미지 높이 조절 가능
              height: MediaQuery.of(context).size.height * 0.5,
              viewportFraction: 1,
              //autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  showedIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, _) {
              // return _imageZoomInOutWidget(widget.images[index]);
              return widget.isProfileScreen
                  // 프로필 화면에서 사용한다면 이미지 확대 기능이 없도록
                  ? _imageWidget(widget.images[index])
                  // 프로필 화면이 아니라면 이미지 확대기능 제공
                  : _imageZoomInOutWidget(widget.images[index]);
            },
          ),
          // 2> 슬라이드 내 이미지 삭제 버튼 (등록 모드일 때)
          if (widget.isNewScreen && widget.images.isNotEmpty && !widget.isAsset)
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                // 피드 올리는 중이라면 이미지 [삭제, X표시] 버튼 비활성화
                onTap: feedStatusEnum == FeedStatusEnum.submitting
                    ? null
                    : () {
                        setState(() {
                          widget.images.removeAt(showedIndex);
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.black.withValues(alpha: 0.6),
                    size: 30,
                  ),
                ),
              ),
            ),
          // 3> Indicator
          Positioned(
            left: 16,
            bottom: 16,
            child: Row(
              children: List.generate(widget.images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: showedIndex == index ? 24 : 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: showedIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
