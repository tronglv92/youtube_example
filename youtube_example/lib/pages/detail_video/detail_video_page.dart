import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:interpolate/interpolate.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/video_controller.dart';
import 'package:youtube_example/pages/home/home_provider.dart';
import 'package:youtube_example/pages/home/video_provider.dart';
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

  // Video video;

  // Chewie Video controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // posY=widget.heightScreen;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      drawComplete = true;
      final Size size = MediaQuery.of(context).size;
      midBound = size.height - 64 * 3;
      upperBound = midBound + minHeight;

      initInterpolate(size);
      toggleUpAnimation(size);
    });

    initControllerAnimation();
    // initializePlayer(videos[0]);
    // video=context.read<VideoProvider>().video;
    // initializePlayer(video);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initializePlayer(Video video) async {
    print("initializePlayer video before " + video.id.toString());
    _videoPlayerController = VideoPlayerController.asset(video.video);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
    _chewieController.addListener(onListenerVideo);
    print("initializePlayer video after " + video.id.toString());
    setState(() {});
  }

  void onListenerVideo() {
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

  void showChiewieController(
      bool show, VideoPlayerController videoPlayerController) {
    _restartChewieController(_videoPlayerController, () {
      if (_videoPlayerController != null) {
        setState(() {
          _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: true,
              showControls: show);
          _chewieController.addListener(onListenerVideo);
        });
      }
    });
  }

  Future<void> _preparePlayNextVideo(Video video, VoidCallback complete) async {
    ChewieController _oldChewieController;
    if (_chewieController != null) {
      _oldChewieController = _chewieController;
    }

    if (_videoPlayerController == null) {
      // If there was no controller, just create a new one
      complete();
    } else {
      // If there was a controller, we need to dispose of the old one first
      _videoPlayerController.pause();
      final oldController = _videoPlayerController;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _oldChewieController.removeListener(onListenerVideo);
        _oldChewieController?.dispose();
        await oldController?.dispose();
        complete();
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        _chewieController = null;
        _videoPlayerController = null;
      });
    }
  }

  void _restartChewieController(
      VideoPlayerController videoPlayerController, VoidCallback complete) {
    if (_chewieController != null) {
      final _oldChewieController = _chewieController;
      _oldChewieController.removeListener(onListenerVideo);
      _oldChewieController?.dispose();

      _chewieController = null;
      complete();
    } else {
      complete();
    }
  }

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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (video?.id != context.read<VideoProvider>().video?.id) {
      Video newVideo = context.read<VideoProvider>().video;
      if (firstBuild == false) {
        animateMoveToTop();
      }
      _preparePlayNextVideo(newVideo, () {
        initializePlayer(newVideo);
      });

      firstBuild = false;
    }
  }

  void animateMoveToTop() {
    // if small mode
    if (snapPoint != 0) {
      snapPoint = 0;
      runAnimateSpring();
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

  void toggleUpAnimation(Size size) {
    Tween<double> toggle = Tween<double>(begin: size.height, end: 0);

    Animation curve =
        CurvedAnimation(parent: _controllerToggle, curve: Curves.ease);
    _animation = toggle.animate(curve);
    _controllerToggle.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _controllerSpring?.dispose();
    _controllerToggle?.dispose();

    super.dispose();
  }

  runAnimateSpring() {
    runSpringComplete = false;

    _animation =
        _controllerSpring?.drive(Tween(begin: translationY, end: snapPoint));

    const spring = SpringDescription(
      damping: 20,
      mass: 1,
      stiffness: 100,
    );

    final simulation = SpringSimulation(spring, 0, 1, 10);

    _controllerSpring?.animateWith(simulation)?.whenCompleteOrCancel(() {
      if (snapPoint == 0) {
        showChiewieController(true, _videoPlayerController);
      }
    });
  }

  onPressCloseVideo() {
    VideoProvider.hideDetailVideo(context: context);
  }

  onPressPlayVideo(bool play) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double opacity = interOpacity != null ? interOpacity.eval(translationY) : 1;

    double videoContainerHeight = ipVideoContainerHeight != null
        ? ipVideoContainerHeight.eval(translationY)
        : size.height;
    double videoHeight = ipVideoHeight != null
        ? ipVideoHeight.eval(translationY)
        : (size.width / 1.78);
    double videoWidth =
        ipVideoWidth != null ? ipVideoWidth.eval(translationY) : size.width;
    video = context.watch<VideoProvider>().video;

    double opacityVideoContent = ipOpacityVideoContent != null
        ? ipOpacityVideoContent.eval(translationY)
        : 1;

    bool modeFullScreen = false;

    if (_chewieController != null) {
      modeFullScreen = _chewieController.isFullScreen;
    }

    return Stack(
      children: [
        Positioned(
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
                GestureDetector(
                  onVerticalDragStart: (DragStartDetails detail) {
                    if (modeFullScreen == false) {
                      showChiewieController(false, _videoPlayerController);
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

                      runAnimateSpring();
                    }
                  },
                  onTap: () {
                    if (modeFullScreen == false) {
                      animateMoveToTop();
                    }
                  },
                  child: Container(
                    height: modeFullScreen == false ? videoHeight : size.height,
                    width: size.width,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        modeFullScreen == false
                            ? VideoController(
                                video: video,
                                onPressClose: onPressCloseVideo,
                                onPressPlay: onPressPlayVideo,
                                opacity: opacityVideoContent,
                              )
                            : Container(),
                        Container(
                            width: modeFullScreen == false
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
                ),
                modeFullScreen == false
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
        ),
      ],
    );
  }
}
