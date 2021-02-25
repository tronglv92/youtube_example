import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/detail_video_page.dart';
import 'package:youtube_example/pages/new_detail/new_detail_video_page.dart';
import 'package:youtube_example/pages/videos/item_video.dart';
import 'package:youtube_example/widgets/p_appbar_empty.dart';

class VideosPage extends StatefulWidget {
  final Function onPress;

  VideosPage({this.onPress});

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {

  OverlayEntry _overlayEntryVideo;

  OverlayEntry createOverlayEntryVideo(Video video) {

    return OverlayEntry(builder: (BuildContext overlayContext) {
       // double height=MediaQuery.of(context).size.height;
      return NewDetailVideoPage(video: video);
    });
  }

  void showOverlayDetailVideo({@required Video video, @required bool show}) {
    if (show == true) {
      if (_overlayEntryVideo == null) {
        _overlayEntryVideo = createOverlayEntryVideo(video);
      }

      OverlayState overlayState = Overlay.of(context);
      overlayState.insert(_overlayEntryVideo);

    } else {
      if (_overlayEntryVideo != null) {
        _overlayEntryVideo.remove();
      }
    }
  }

  onPressItem(Video video) {
    // Navigator.of(context).push( MaterialPageRoute(builder: (context) =>DetailVideoPage(video: video,)),);
    // widget.onPress(video);

    showOverlayDetailVideo(video: video, show: true);
  }

  @override
  Widget build(BuildContext context) {
    return PAppBarEmpty(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Video',
              style: TextStyle(color: Colors.white),
            ),
          ),
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
      ),
    );
  }
}
