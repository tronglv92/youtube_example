import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/home/home_provider.dart';

import 'package:youtube_example/pages/detail_video/detail_video_page.dart';
import 'package:youtube_example/pages/videos/item_video.dart';
import 'package:youtube_example/widgets/p_appbar_empty.dart';
import 'package:provider/provider.dart';
class VideosPage extends StatefulWidget {
  final Function onPress;


  VideosPage({this.onPress});

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> with AutomaticKeepAliveClientMixin{



  onPressItem(Video video) {


    widget.onPress(video);
  }

  @override
  Widget build(BuildContext context) {
    print("vao trong nay ");
    super.build(context);
    return CustomScrollView(
      slivers: [

        SliverFixedExtentList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            Video video = videos[index];

            return ItemVideo(
              video: video,
              onPress: () {
                onPressItem(video);
              },
            );
          }, childCount: videos.length),
          itemExtent: 310,
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
