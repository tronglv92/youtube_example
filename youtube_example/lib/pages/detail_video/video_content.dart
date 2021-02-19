import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';

import 'icon_action.dart';

class VideoContent extends StatelessWidget {
  final Video video;
  VideoContent({this.video});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          video.title,
          style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500),
          maxLines: 2,
        ),
        SizedBox(height: 10,),
        Text(
          video.username +
              " - " +
              video.views.toString() +
              " views",
          style: TextStyle(fontSize: 12, color: Colors.grey),
          maxLines: 2,
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconAction(icon:   Icons.thumb_up_alt_outlined,message: "100",),
            IconAction(icon:   Icons.thumb_down_alt_outlined,message: "5",),
            IconAction(icon:   Icons.share_outlined,message: "Share",),
            IconAction(icon:   Icons.download_outlined,message: "Download",),
            IconAction(icon:   Icons.add_box_outlined,message: "Save",),

          ],
        ),

      ],
    );
  }
}
