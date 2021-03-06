import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/widgets/sweet_video/chewie_player.dart';

class TestDetailVideo extends StatefulWidget {
  @override
  _TestDetailVideoState createState() => _TestDetailVideoState();
}

class _TestDetailVideoState extends State<TestDetailVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer(videos[0]);
  }
  Future<void> initializePlayer(Video video) async {
    print("initializePlayer video before " + video.id.toString());
    _videoPlayerController = VideoPlayerController.asset(video.video);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        fullScreenByDefault: false,
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
  @override
  Widget build(BuildContext context) {

    return Positioned(
        top: 0,
        child: Material(
          child: Column(
            children: [
              Container(
                  height: (_chewieController!=null && _chewieController.isFullScreen==true)?MediaQuery.of(context).size.height:200,
                  color: Colors.black,
                  child: _videoPlayerController != null &&
                      _chewieController != null &&
                      _chewieController
                          .videoPlayerController
                          .value
                          .initialized
                      ? Chewie(controller: _chewieController)
                      : Center(
                    child: CircularProgressIndicator(),
                  )),
              (_chewieController!=null && _chewieController.isFullScreen==true)?Container(): Container(height: 300,color: Colors.blue,)
            ],
          ),
        ));
  }
}
