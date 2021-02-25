import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interpolate/interpolate.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/video_content.dart';
import 'package:youtube_example/pages/videos/item_video.dart';

class DetailVideoPage extends StatefulWidget {
  DetailVideoPage({this.video, this.heightScreen});

  final Video video;
  final double heightScreen;

  @override
  _DetailVideoPageState createState() => _DetailVideoPageState();
}

class _DetailVideoPageState extends State<DetailVideoPage>
    with SingleTickerProviderStateMixin {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  double posY = 0;

  final double minHeight = 64;
  double midBound;
  double upperBound;
  double lowerBound;

  // Animation<double> _animationOpacity;
  // AnimationController _controllerOpacity;
  Interpolate opacityValue;

  bool modBig = true;

  // width and height video

  Interpolate widthValue;

  Interpolate heightValue;

  void initAnimation() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    midBound = height - 64 * 3;
    upperBound = midBound + minHeight;
    lowerBound = height * 1 / 4;
    opacityValue = Interpolate(
        inputRange: [0, midBound - 100],
        outputRange: [1, 0],
        extrapolate: Extrapolate.clamp);

    widthValue = Interpolate(
        inputRange: [0, height - midBound,height -   minHeight],
        outputRange: [width, width-16, width/3],
        extrapolate: Extrapolate.clamp);
    heightValue = Interpolate(
        inputRange: [0, height],
        outputRange: [240, minHeight],
        extrapolate: Extrapolate.clamp);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // posY=widget.heightScreen;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // setState(() {
      //   posY= 0;
      // });

      initAnimation();
    });

    // initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.video.video);

    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);

    _chewieController.addListener(() {});
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double opacity = 1;
    if (opacityValue != null) {
      opacity = opacityValue.eval(posY);
    }

    double widthVideo = width;
    double heightVideo = 240;
    if (widthValue != null) {
      widthVideo = widthValue.eval(posY);
      print("posY " + posY.toString());
      print("widthVideo " + widthVideo.toString());
    }
    if (heightValue != null) {
      heightVideo = heightValue.eval(posY);
    }

    return AnimatedPositioned(
      width: width,
      height: height,
      duration: Duration(milliseconds: 500),
      top: posY,
      // duration: new Duration(milliseconds: 300),
      child: Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails update) {
                // update.delta.dy

                if (posY >= 0 && posY <= height - minHeight) {
                  setState(() {
                    if (posY <= height - minHeight + 100) {
                      posY = posY + update.delta.dy;
                    } else {
                      posY = posY + 0.5 * update.delta.dy;
                    }

                    if (posY <= 0) {
                      posY = 0;
                    } else if (posY >= height - minHeight) {
                      posY = height - minHeight;
                    }
                  });
                }
              },
              onVerticalDragEnd: (DragEndDetails endDetail) {
                if (modBig == true) {
                  if (posY >= height - upperBound) {
                    if (posY != height - minHeight) {
                      setState(() {
                        posY = height - minHeight;
                        modBig = false;
                      });
                    }
                  } else {
                    if (posY != 0) {
                      setState(() {
                        posY = 0;
                        modBig = true;
                      });
                    }
                  }
                } else {
                  if (posY >= height - lowerBound) {
                    if (posY != height - minHeight) {
                      setState(() {
                        posY = height - minHeight;
                        modBig = false;
                      });
                    }
                  } else {
                    if (posY != 0) {
                      setState(() {
                        posY = 0;
                        modBig = true;
                      });
                    }
                  }
                }
              },
              child: Container(
                height: heightVideo,
                color: Colors.red,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: heightVideo,
                      width: widthVideo,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Opacity(
              opacity: opacity,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
    );
  }
}
