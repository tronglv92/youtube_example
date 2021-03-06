import 'package:flutter/material.dart';
import 'package:interpolate/interpolate.dart';
import 'package:provider/provider.dart';
import 'package:youtube_example/pages/home/home_provider.dart';
import 'package:youtube_example/pages/home/bottom_tab/tab_item.dart';

const double HEIGHT_TAB = 55;

class AnimatedBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onChangeTabSelected;

  AnimatedBottomNavigationBar({@required this.onChangeTabSelected});

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> {
  int activeIndex;
  Interpolate ipTranslationYBottomBar;
  double upperBound = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Size size = MediaQuery.of(context).size;

      upperBound = size.height - 64 * 2;

      initInterpolate(size);
    });
  }
  void initInterpolate(Size size) {
    ipTranslationYBottomBar = Interpolate(
        inputRange: [0, upperBound],
        outputRange: [HEIGHT_TAB, 0],
        extrapolate: Extrapolate.clamp);

  }
  @override
  void didUpdateWidget(covariant AnimatedBottomNavigationBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.activeIndex != widget.activeIndex) {
    //
    // }
    // print("didUpdateWidget oldWidget.activeIndex "+widget.activeIndex.toString());
  }

  @override
  Widget build(BuildContext context) {

    int activeIndex = context.watch<HomeProvider>().currentIndexPage;
    double translationY = context.watch<HomeProvider>().translationY;
    double translationYBottomTab=ipTranslationYBottomBar!=null?ipTranslationYBottomBar.eval(translationY):HEIGHT_TAB;
    return Container(
      height: HEIGHT_TAB,
      child: Stack(
        children: [
          Positioned(
            top: translationYBottomTab,
            height: HEIGHT_TAB,
            width: MediaQuery.of(context).size.width,
            child: Container(
              // margin: EdgeInsets.only(top: 45),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
              ]),
              child: Row(
                // mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TabItem(
                      selected: activeIndex == 0,
                      iconDataOn: Icons.home,
                      iconDataOff: Icons.home_outlined,
                      title: "Home",
                      callbackFunction: () {
                        // setState(() {
                        //   currentSelected = 0;
                        // });
                        widget.onChangeTabSelected(0);
                      }),
                  TabItem(
                      selected: activeIndex == 1,
                      iconDataOn: Icons.explore,
                      iconDataOff: Icons.explore_outlined,
                      title: "Explore",
                      callbackFunction: () {
                        // setState(() {
                        //   currentSelected = 1;
                        // });
                        widget.onChangeTabSelected(1);
                      }),
                  TabItem(
                      iconDataOn: Icons.add_circle_outline,
                      middle: true,
                      callbackFunction: () {}),
                  TabItem(
                      selected: activeIndex == 2,
                      iconDataOn: Icons.video_call,
                      iconDataOff: Icons.video_call_outlined,
                      title: "Register",
                      callbackFunction: () {
                        // setState(() {
                        //   currentSelected = 2;
                        // });
                        widget.onChangeTabSelected(2);
                      }),
                  TabItem(
                      selected: activeIndex == 3,
                      iconDataOn: Icons.video_library,
                      iconDataOff: Icons.video_library_outlined,
                      title: "Library",
                      callbackFunction: () {
                        // setState(() {
                        //   currentSelected = 3;
                        // });
                        widget.onChangeTabSelected(3);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
