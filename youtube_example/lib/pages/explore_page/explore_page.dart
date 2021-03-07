
import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/videos_page/item_video.dart';

class ExplorePage extends StatefulWidget {
  final Function onPress;

  ExplorePage({this.onPress, Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();

  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
  onPressItem(Video video) {
    widget.onPress(video);
  }

  @override
  Widget build(BuildContext context) {
    print("build ExplorePage ");
    super.build(context);
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {

          return ListView.builder(
            controller: _scrollController,
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
