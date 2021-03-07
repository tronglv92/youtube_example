import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';

import 'package:youtube_example/pages/videos_page/item_video.dart';

class VideosPage extends StatefulWidget {
  final Function onPress;


  VideosPage({this.onPress, Key key}) : super(key: key);

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController();

  }

  @override
  void dispose() {
    super.dispose();
  }

  onPressItem(Video video) {
    widget.onPress(video);
  }

  @override
  Widget build(BuildContext context) {
    print("build VideosPage ");
    super.build(context);
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          return ListView.builder(

            itemBuilder: (BuildContext context, int index) {
              Video video = videos[index];
              return ItemVideo(
                video: video,
                onPress: () {
                  onPressItem(video);
                },
              );
            },
            itemCount: videos.length,
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
