import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';

class VideoController extends StatefulWidget {
  final Video video;
  final Function onPressPlay;
  final Function onPressClose;
  final double opacity;
  VideoController({@required this.video,@required this.onPressPlay,@required this.onPressClose,this.opacity});

  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  bool play=true;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Opacity(
        opacity: widget.opacity,
        child: Row(
          children: [
            Container(width: size.width / 3,),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video?.title,
                        maxLines: 1,
                      ),
                      Text(widget.video?.username)
                    ],
                  ),
                )),
            IconButton(
                icon: Icon(play==true?Icons.pause:Icons.play_arrow), onPressed: () {
                  setState(() {
                    play=!play;
                  });
                  widget.onPressPlay(play);
            }),
            IconButton(
                icon: Icon(Icons.close), onPressed: () {
                  widget.onPressClose();
            })
          ],
        ),
      ),
    );
  }
}
