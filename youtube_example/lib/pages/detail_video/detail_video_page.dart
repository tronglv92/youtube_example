import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/video_content.dart';
import 'package:youtube_example/pages/videos/item_video.dart';
import 'package:youtube_example/widgets/p_appbar_empty.dart';

class DetailVideoPage extends StatefulWidget {
  DetailVideoPage({this.video});

  final Video video;

  @override
  _DetailVideoPageState createState() => _DetailVideoPageState();
}

class _DetailVideoPageState extends State<DetailVideoPage> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    // TODO: implement dispose
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
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
  Widget build(BuildContext context) {
    return PAppBarEmpty(
        child: Column(
      children: [
        AspectRatio (
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: _chewieController != null &&
                  _chewieController.videoPlayerController.value.initialized
              ? Chewie(controller: _chewieController)
              : Container(
                  color: Colors.red,
                ),
        ),
        Expanded(
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
        ))
      ],
    ));
  }
}
