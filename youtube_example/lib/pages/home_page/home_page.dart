import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_example/modals/video.dart';
import 'package:youtube_example/pages/explore_page/explore_page.dart';
import 'package:youtube_example/pages/home_page/home_provider.dart';
import 'package:youtube_example/pages/detail_video_page/video_provider.dart';
import 'package:youtube_example/pages/library_page/library_page.dart';
import 'package:youtube_example/pages/register_page/register_page.dart';

import 'package:youtube_example/pages/videos_page/videos_page.dart';

import 'bottom_tab/bottom_tab.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController?.dispose();
    _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // https://github.com/flutter/flutter/issues/36419
    // Because this issue so I can't make scroll like youtube, wait flutter fix it, I try many ways but not success
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  title: Text("Video"),
                  pinned: false,
                  floating: true,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                ),
              ),
            ),
          ];
        },
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (int index) {
            context.read<HomeProvider>().changePage(index);
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return VideosPage(
                onPress: onPressVideo,

                key: ValueKey(index),
              );
            } else if (index == 1) {
              return ExplorePage(
                onPress: onPressVideo,

                key: ValueKey(index),
              );
            } else if (index == 2) {
              return RegisterPage();
            } else {
              return LibraryPage();
            }
          },
          itemCount: 4,
        ),
      ),
      bottomNavigationBar: BottomTab(
        onChangeTabSelected: onChangeTabSelected,
      ),
    );
  }
}
