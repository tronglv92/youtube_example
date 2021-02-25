import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:interpolate/interpolate.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/video_content.dart';
import 'package:youtube_example/pages/videos/item_video.dart';

class NewDetailVideoPage extends StatefulWidget {
  NewDetailVideoPage({this.video});

  final Video video;

  @override
  _NewDetailVideoPageState createState() => _NewDetailVideoPageState();
}

class _NewDetailVideoPageState extends State<NewDetailVideoPage>
    with TickerProviderStateMixin {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  // toggle video
  // AnimationController _positionTopController;
  // Animation<double> _animation;
  // Interpolate translateYIpl;
  AnimationController _controller;
  SpringSimulation simulation;
  Animation<double> _animation;

  // Drag vertical
  double translationY = 0;
  double snapPoint = 0;

  // double offsetY=0;

  final double minHeight = 64;
  double midBound = 0;
  double upperBound = 0;

  Interpolate interOpacity;

  Interpolate ipVideoContainerWidth;
  Interpolate ipVideoContainerHeight;
  Interpolate ipVideoHeight;
  Interpolate ipVideoWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // posY=widget.heightScreen;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Size size = MediaQuery.of(context).size;
      midBound = size.height - 64 * 3;
      upperBound = midBound + minHeight;

      initInterpolate(size);
    });
    _controller =
        AnimationController(vsync: this, upperBound: 500, lowerBound: -500)
          ..addListener(() {
            setState(() {
              translationY = _animation.value;
              // offsetY=translationY;
            });
          });
    // initializePlayer();
  }

  void initInterpolate(Size size) {
    interOpacity = Interpolate(
        inputRange: [0, upperBound - 100],
        outputRange: [1.0, 0.0],
        extrapolate: Extrapolate.clamp);
    ipVideoContainerWidth = Interpolate(
        inputRange: [0, midBound],
        outputRange: [size.width, size.width - 16],
        extrapolate: Extrapolate.clamp);
    ipVideoContainerHeight=Interpolate(inputRange:[0,midBound] ,outputRange:[size.height,0] ,extrapolate: Extrapolate.clamp);
    ipVideoHeight=Interpolate(inputRange:[0,midBound,upperBound] ,outputRange:[(size.width/1.78),minHeight*1.3,minHeight] ,extrapolate: Extrapolate.clamp);
    ipVideoWidth = Interpolate( inputRange: [0, midBound, upperBound],
        outputRange: [size.width, size.width - 16, size.width / 3],
        extrapolate: Extrapolate.clamp);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    // _positionTopController?.dispose();

    super.dispose();
  }

  runAnimate(Offset pixelsPerSecond, Size size) {
    // endDetail.velocity.pixelsPerSecond
    _animation = _controller.drive(Tween(begin: translationY, end: snapPoint));
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      damping: 20,
      mass: 1,
      stiffness: 100,
    );

    final simulation = SpringSimulation(spring, 0, 1, 10);

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double opacity = interOpacity != null ? interOpacity.eval(translationY) : 1;
    double videoContainerWidth = ipVideoContainerWidth != null
        ? ipVideoContainerWidth.eval(translationY)
        : size.width;
    double videoContainerHeight = ipVideoContainerHeight != null
        ? ipVideoContainerHeight.eval(translationY)
        : size.height;
    double videoHeight=ipVideoHeight!=null?ipVideoHeight.eval(translationY):(size.width/1.78);
    double videoWidth=ipVideoWidth!=null?ipVideoWidth.eval(translationY):size.width;
    return Stack(
      children: [
        Positioned(
          top: translationY,
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onVerticalDragDown: (DragDownDetails details) {
                    _controller?.stop();
                  },
                  onVerticalDragUpdate: (DragUpdateDetails update) {
                    setState(() {
                      translationY = translationY + update.delta.dy;
                    });
                  },
                  onVerticalDragEnd: (DragEndDetails endDetail) {
                    if (translationY < (snapPoint - size.height / 4).abs()) {
                      snapPoint = 0;
                    } else {
                      snapPoint = upperBound;
                    }

                    runAnimate(endDetail.velocity.pixelsPerSecond, size);
                  },
                  child: Container(
                    height: videoHeight,
                    width: size.width,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(

                          width: videoWidth,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    width: videoContainerWidth,
                    height: videoContainerHeight,
                    color: Colors.white,
                    child: Opacity(
                      opacity: opacity,
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        children: [
                          VideoContent(
                            video: widget.video,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Next up",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              Video video = videos[index];
                              return ItemVideo(
                                video: video,
                                isPadding: false,
                              );
                            },
                            itemCount: videos.length,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
