import 'package:flutter/material.dart';
import 'package:youtube_example/modals/video.dart';
class ItemVideo extends StatelessWidget {
  ItemVideo({this.video,this.isPadding=true,this.onPress});
  final Video video;
  final bool isPadding;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            video.thumbnail,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding:  EdgeInsets.only(
                top: 15, bottom: 20, left: isPadding==true? 10:0, right: isPadding==true? 10:0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35 / 2),
                  child: Image.asset(
                    video.avatar,
                    height: 35,
                    width: 35,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(

                        video.username +
                            ' - ' +
                            video.views.toString() +
                            ' views ',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
