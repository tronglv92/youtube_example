import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/home/home_provider.dart';
import 'package:youtube_example/pages/home/video_provider.dart';
import 'package:youtube_example/pages/test_page/test2_screen.dart';
import 'package:youtube_example/pages/test_page/test3_screen.dart';
import 'package:youtube_example/pages/test_page/test4_screen.dart';
import 'package:youtube_example/pages/videos/videos_page.dart';

import 'bottom_tab/animated_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  PageController _pageController;
  ScrollController _scrollController;

  void onPressVideo(Video vd) {
    VideoProvider.showDetailVideo(context: context, video: vd);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(initialPage: _pageIndex);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Size size = MediaQuery.of(context).size;
      context.read<HomeProvider>().animationTranslationY(size.height);
    });
  }

  void onChangeTabSelected(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void showDialogTest() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height: 300.0,
              width: 300.0,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Cool',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Awesome',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50.0)),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Got It!',
                        style: TextStyle(color: Colors.purple, fontSize: 18.0),
                      ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("Video"),
              pinned: false,
              floating: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (int index) {
            // this.setState(() {
            //   _pageIndex=index;
            // });
            context.read<HomeProvider>().changePage(index);
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return VideosPage(
                onPress: onPressVideo,
              );
            } else if (index == 1) {
              return Test2Screen();
            } else if (index == 2) {
              return Test3Screen();
            } else {
              return Test4Screen();
            }
          },
          itemCount: 4,
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        onChangeTabSelected: onChangeTabSelected,
      ),
    );
  }
}
