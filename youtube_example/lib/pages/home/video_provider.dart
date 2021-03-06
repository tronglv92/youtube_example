import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/detail_video/detail_video_page.dart';
import 'package:youtube_example/pages/test_page/test_detail_video.dart';


class VideoProvider extends ChangeNotifier{

  Video _video;
  Video get video=>_video;
  OverlayEntry _overlayEntryVideo;
  OverlayState _overlayState;


  static showDetailVideo({@required BuildContext context,@required Video video})
  {
    context.read<VideoProvider>().openDetailVideo(context: context,video: video);
  }

  static hideDetailVideo({@required BuildContext context})
  {
    context.read<VideoProvider>().closeDetailVideo(context: context);
  }
  void updateVideo(Video video)
  {
    _video=video;
    notifyListeners();
  }

  OverlayEntry createOverlayEntryVideo() {

    return OverlayEntry(builder: (BuildContext overlayContext) {
      // double height=MediaQuery.of(context).size.height;

      return DetailVideoPage();
    });
  }
  void showOrHideOverlayVideo({ @required BuildContext context, @required bool show})
  {
    if (show == true) {
      if (_overlayEntryVideo == null) {
        _overlayEntryVideo = createOverlayEntryVideo();
      }

      _overlayState = Overlay.of(context);
      _overlayState.insert(_overlayEntryVideo);


    } else {
      if (_overlayEntryVideo != null) {
        _overlayEntryVideo.remove();
        _overlayEntryVideo=null;
      }
    }
  }
  bool overlayVideoIsShow()=>_overlayEntryVideo!=null;
  openDetailVideo({BuildContext context,Video video})
  {
    updateVideo(video);
    if(overlayVideoIsShow()==false)
      {
        showOrHideOverlayVideo(show: true,context: context);

      }

  }
  closeDetailVideo({BuildContext context})
  {
    showOrHideOverlayVideo(context: context, show: false);
    // updateVideo(null);
  }
}
