import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/video_content.dart';
import 'package:youtube_example/pages/videos/item_video.dart';
class BigModeVideo extends StatelessWidget {
  final ChewieController chewieController;
  final Video video;
  BigModeVideo({this.chewieController,this.video});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails update){
              // update.delta.dy
            },
            child: Container(
              height: 240,
              child: chewieController != null &&
                  chewieController.videoPlayerController.value.initialized
                  ? Chewie(controller: chewieController)
                  : Container(
                // color: Colors.red,
              ),
            ),
          ),

          Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  VideoContent(
                    video: video,
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
      ),
    );
  }
}
