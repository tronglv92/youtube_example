
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:youtube_example/pages/home_page/home_page.dart';
import 'package:youtube_example/pages/home_page/home_provider.dart';


import 'package:youtube_example/pages/detail_video_page/video_provider.dart';



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

  @override
  Widget build(BuildContext context) {


    /// Build Material app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context)=>HomeProvider()),
        ChangeNotifierProvider<VideoProvider>(create: (_) => VideoProvider()),
        // Provider(create: (BuildContext context) => VideoProvider(),)
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: HomePage()

        // NewDetailVideoPage(video: videos[0],),
      ),
    );
  }


}
