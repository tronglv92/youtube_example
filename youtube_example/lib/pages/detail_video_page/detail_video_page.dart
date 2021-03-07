import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:interpolate/interpolate.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video_page/video_controller.dart';
import 'package:youtube_example/pages/home_page/bottom_tab/bottom_tab.dart';
import 'package:youtube_example/pages/home_page/home_provider.dart';
import 'package:youtube_example/pages/detail_video_page/video_provider.dart';
import 'package:youtube_example/widgets/sweet_video/chewie_player.dart';

import 'video_body.dart';

class DetailVideoPage extends StatefulWidget {
  DetailVideoPage();

  @override
  _DetailVideoPageState createState() => _DetailVideoPageState();
}

class _DetailVideoPageState extends State<DetailVideoPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _controllerSpring;
  bool runSpringComplete = true;
  SpringSimulation simulation;
  Animation<double> _animation;

  AnimationController _controllerToggle;
  double toggleTranslationY = 0;
  bool toggleComplete = false;
  bool drawComplete = false;

  // Drag vertical
  double translationY = 0;
  double snapPoint = 0;

  // double offsetY=0;

  final double minHeight = 64;
  double midBound = 0;
  double upperBound = 0;

  Interpolate interOpacity;

  Interpolate ipVideoContainerHeight;
  Interpolate ipVideoHeight;
  Interpolate ipVideoWidth;
  Interpolate ipOpacityVideoContent;
  Video video;
  bool firstBuild = true;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool isVideoPlay=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      drawComplete = true;
      final Size size = MediaQuery.of(context).size;
      midBound = size.height - 64 * 3;
      upperBound = midBound + minHeight+8;

      initInterpolate(size);
      slideUpAnimation(size);
    });

    initControllerAnimation();
  }

  // ============= SETUP VIDEO ======================

  Future<void> initializePlayer(Video video) async {

    _videoPlayerController = VideoPlayerController.asset(video.video);
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(onVideoListener);

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
    _chewieController.addListener(onChewieListener);

    setState(() {});
  }


  void onVideoListener(){

    if(_videoPlayerController!=null && _videoPlayerController?.value?.isPlaying!=isVideoPlay)
      {

        setState(() {
          isVideoPlay=_videoPlayerController?.value?.isPlaying;
        });
      }

  }

  void onChewieListener() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (_chewieController != null) {



      if (_chewieController.isFullScreen && isPortrait) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      } else if (!_chewieController.isFullScreen && !isPortrait) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }

    }
  }

  void showOrHideChiewieController(
      bool show, VideoPlayerController videoPlayerController) {
    _restartChewieController(onComplete: () {
      if (_videoPlayerController != null) {
        setState(() {
          _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: isVideoPlay,
              showControls: show);
          _chewieController.addListener(onChewieListener);
        });
      }
    });
  }

  void _restartChewieController({VoidCallback onComplete}) {
    if (_chewieController != null) {
      final _oldChewieController = _chewieController;
      _oldChewieController.removeListener(onChewieListener);
      _oldChewieController?.dispose();

      _chewieController = null;
      if (onComplete != null) onComplete();
    } else {
      if (onComplete != null) onComplete();
    }
  }

  Future<void> _preparePlayNextVideo(Video video, VoidCallback complete) async {
    // _restartChewieController();
    ChewieController _oldChewieController;
    if(_chewieController!=null)
      {
           _oldChewieController = _chewieController;
      }
    if (_videoPlayerController == null) {
      // If there was no controller, just create a new one
      complete();
    } else {
      // If there was a controller, we need to dispose of the old one first
      _videoPlayerController.pause();
      final oldVideoController = _videoPlayerController;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _oldChewieController?.removeListener(onChewieListener);
        _oldChewieController?.dispose();

        oldVideoController?.removeListener(onVideoListener);
        await oldVideoController?.dispose();
        complete();
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        _chewieController = null;
        _videoPlayerController = null;
      });
    }
  }
// ============= END SETUP VIDEO ======================


  // =============  SETUP ANIMATION ======================
  void initControllerAnimation() {
    _controllerSpring =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {
            setTranslationY(_animation.value);
            // widget.onChangeTranslationY(translationY);
          })
          ..addStatusListener((AnimationStatus status) {
            runSpringComplete = true;
          });

    _controllerToggle =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              toggleTranslationY = _animation.value;
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              toggleComplete = true;
            }
          });
  }


  void animateMoveToTop() {
    // if small mode
    if (snapPoint != 0) {
      snapPoint = 0;
      runAnimateSpring(begin: translationY,end: snapPoint);
    }
  }

  void setTranslationY(double translationY) {
    setState(() {
      this.translationY = translationY;
    });

    context.read<HomeProvider>()?.animationTranslationY(translationY);
  }

  void initInterpolate(Size size) {
    interOpacity = Interpolate(
        inputRange: [0, upperBound - 100],
        outputRange: [1.0, 0.0],
        extrapolate: Extrapolate.clamp);

    ipVideoContainerHeight = Interpolate(
        inputRange: [0, midBound],
        outputRange: [size.height, 0],
        extrapolate: Extrapolate.clamp);
    ipVideoHeight = Interpolate(
        inputRange: [0, midBound, upperBound],
        outputRange: [(size.width / 1.78), minHeight * 1.3, minHeight],
        extrapolate: Extrapolate.clamp);
    ipVideoWidth = Interpolate(
        inputRange: [0, midBound, upperBound],
        outputRange: [size.width, size.width, size.width / 3],
        extrapolate: Extrapolate.clamp);
    ipOpacityVideoContent = Interpolate(
        inputRange: [midBound, upperBound],
        outputRange: [0.0, 1.0],
        extrapolate: Extrapolate.clamp);
  }

  void slideUpAnimation(Size size) {
    Tween<double> toggle = Tween<double>(begin: size.height, end: 0);

    Animation curve =
        CurvedAnimation(parent: _controllerToggle, curve: Curves.ease);
    _animation = toggle.animate(curve);
    _controllerToggle.forward();
  }
  runAnimateSpring({double begin, double end}) {
    runSpringComplete = false;

    _animation =
        _controllerSpring?.drive(Tween(begin: begin, end: end));

    const spring = SpringDescription(
      damping: 20,
      mass: 1,
      stiffness: 100,
    );

    final simulation = SpringSimulation(spring, 0, 1, 10);

    _controllerSpring?.animateWith(simulation)?.whenCompleteOrCancel(() {
      if (snapPoint == 0) {
        showOrHideChiewieController(true, _videoPlayerController);
      }
    });
  }
// =============  END SETUP ANIMATION ======================
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Video newVideo = context.read<VideoProvider>().video;
    if (video?.id != newVideo?.id) {

      // if (firstBuild == false) {
      //
      // }
      isVideoPlay=true;
      _preparePlayNextVideo(newVideo, () {
        initializePlayer(newVideo);
      });
      //
      // firstBuild = false;
    }
    print("didChangeDependencies");
    animateMoveToTop();

  }


  disposeVideo()
  {
    _chewieController?.pause();
    _videoPlayerController?.removeListener(onVideoListener);
    _videoPlayerController?.dispose();

    _chewieController?.removeListener(onChewieListener);
    _chewieController?.dispose();
    _controllerSpring?.dispose();
    _controllerToggle?.dispose();
  }
  @override
  void dispose() {
    // TODO: implement dispose

    disposeVideo();
    super.dispose();
  }



  onPressCloseVideo() {
    _videoPlayerController?.removeListener(onVideoListener);
    _chewieController?.removeListener(onChewieListener);
    VideoProvider.hideDetailVideo(context: context);

  }

  onPressPlayVideo() {


    setState(() {
      isVideoPlay=!isVideoPlay;
      if(isVideoPlay==true)
      {
        _chewieController?.play();
      }
      else

      {
        _chewieController?.pause();
      }
    });



  }

  @override
  Widget build(BuildContext context) {
    video = context.watch<VideoProvider>().video;

    final Size size = MediaQuery.of(context).size;
    final double opacity =
        interOpacity != null ? interOpacity.eval(translationY) : 1;
    final double videoContainerHeight = ipVideoContainerHeight != null
        ? ipVideoContainerHeight.eval(translationY)
        : size.height;
    final double videoHeight = ipVideoHeight != null
        ? ipVideoHeight.eval(translationY)
        : (size.width / 1.78);
    final double videoWidth =
        ipVideoWidth != null ? ipVideoWidth.eval(translationY) : size.width;
    final double opacityVideoContent = ipOpacityVideoContent != null
        ? ipOpacityVideoContent.eval(translationY)
        : 1;

    bool modeVideoFullScreen = false;
    if (_chewieController != null) {
      modeVideoFullScreen = _chewieController.isFullScreen;
    }

    return Positioned(
      top: drawComplete == true
          ? toggleComplete == false
              ? toggleTranslationY
              : translationY
          : size.height,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _onGestureVideo(
                size: size,
                child: Container(
                  height:
                      modeVideoFullScreen == false ? videoHeight : size.height,
                  width: size.width,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      modeVideoFullScreen == false
                          ? VideoController(
                              video: video,
                              play: _chewieController?.isPlaying,
                              onPressClose: onPressCloseVideo,
                              onPressPlay: onPressPlayVideo,
                              opacity: opacityVideoContent,
                            )
                          : Container(),
                      Container(
                          width: modeVideoFullScreen == false
                              ? videoWidth
                              : size.width,
                          color: Colors.black,
                          child: _videoPlayerController != null &&
                                  _chewieController != null &&
                                  _chewieController
                                      .videoPlayerController.value.initialized
                              ? Chewie(controller: _chewieController)
                              : Center(
                                  child: CircularProgressIndicator(),
                                )),
                    ],
                  ),
                ),
                modeFullScreen: modeVideoFullScreen),
            modeVideoFullScreen == false
                ? Container(
                    width: size.width,
                    height: videoContainerHeight,
                    color: Colors.white,
                    child: Opacity(
                      opacity: opacity,
                      child: VideoBody(
                        video: video,
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  GestureDetector _onGestureVideo({
    @required Widget child,
    @required Size size,
    bool modeFullScreen = false,
  }) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails detail) {
        if (modeFullScreen == false) {
          showOrHideChiewieController(false, _videoPlayerController);
        }
      },
      onVerticalDragDown: (DragDownDetails details) {
        if (modeFullScreen == false) {
          _controllerSpring?.stop();
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails update) {
        if (modeFullScreen == false) {
          setTranslationY(translationY + update.delta.dy);
        }
      },
      onVerticalDragEnd: (DragEndDetails endDetail) {
        if (modeFullScreen == false) {
          if (translationY < (snapPoint - size.height / 4).abs()) {
            snapPoint = 0;
          } else {
            snapPoint = upperBound;
          }

          runAnimateSpring(begin: translationY,end: snapPoint);
        }
      },
      onTap: () {
        if (modeFullScreen == false) {
          animateMoveToTop();
        }
      },
      child: child,
    );
  }
}
