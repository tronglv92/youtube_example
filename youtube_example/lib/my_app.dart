
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:youtube_example/pages/detail_video/detail_video_page.dart';
import 'package:youtube_example/pages/new_detail/new_detail_video_page.dart';
import 'package:youtube_example/pages/test/draggable_card.dart';
import 'package:youtube_example/pages/test/physics_animation.dart';
import 'package:youtube_example/pages/videos/videos_page.dart';

import 'modals/video.dart';

Future<void> myMain() async {
  /// Start services later
  WidgetsFlutterBinding.ensureInitialized();

  /// Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  /// Run Application
  runApp(
      MyApp()
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // OverlayEntry _overlayEntryVideo;
  // final navkey = GlobalKey<NavigatorState>();


  @override
  void initState() {
    super.initState();

  }

  // OverlayEntry createOverlayEntryVideo(Video video){
  //   return OverlayEntry(builder: (BuildContext overlayContext){
  //     return DetailVideoPage(video: video);
  //   });
  // }
  //
  // void showOverlayDetailVideo({@required Video video,@required bool show})
  // {
  //   if(show==true)
  //     {
  //       if(_overlayEntryVideo==null)
  //       {
  //         _overlayEntryVideo=createOverlayEntryVideo(video);
  //       }
  //       OverlayState overlay = navkey.currentState.overlay;
  //       overlay.insert(_overlayEntryVideo);
  //     }
  //   else
  //     {
  //       if(_overlayEntryVideo!=null)
  //         {
  //           _overlayEntryVideo.remove();
  //         }
  //     }
  //
  // }
  //


  @override
  Widget build(BuildContext context) {


    /// Build Material app
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewDetailVideoPage(video: videos[0],)

      // NewDetailVideoPage(video: videos[0],),
    );
  }


}
