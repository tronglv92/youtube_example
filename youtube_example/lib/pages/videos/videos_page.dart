import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/detail_video_page.dart';
import 'package:youtube_example/pages/videos/item_video.dart';
import 'package:youtube_example/widgets/p_appbar_empty.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {

  onPressItem(Video video)
  {
    Navigator.of(context).push( MaterialPageRoute(builder: (context) =>DetailVideoPage(video: video,)),);
  }
  @override
  Widget build(BuildContext context) {
    return PAppBarEmpty(
      child: CustomScrollView(

        slivers: [
          SliverAppBar(
            title: Text('Video',style: TextStyle(color: Colors.white),),

          ),

            SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context,int index){
                    Video video = videos[index];

                    return ItemVideo(video: video,onPress: (){
                      onPressItem(video);
                    },);
                  },
                childCount: videos.length

              ),
              itemExtent: 310,
          )
        ],
      ),
    );
  }
}
