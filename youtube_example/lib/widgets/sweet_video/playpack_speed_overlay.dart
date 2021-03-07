import 'package:flutter/material.dart';

const double heightModal = 300;

class PlayPackSpeedOverlay extends StatefulWidget {
  PlayPackSpeedOverlay({this.speeds, this.selected,this.onPressItem,this.onPressOutside});

  final List<double> speeds;
  final double selected;
  final Function onPressItem;
  final Function onPressOutside;
  @override
  _PlayPackSpeedOverlayState createState() => _PlayPackSpeedOverlayState();
}

class _PlayPackSpeedOverlayState extends State<PlayPackSpeedOverlay> {
  double selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selected;
  }

  void onPressItem(double selected) {
    this.setState(() {
      this.selected = selected;
    });
    widget.onPressItem(this.selected);
  }

  void onPressOutSide()
  {
    widget.onPressOutside();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Positioned.fill(
        child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onPressOutSide,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                width: size.width,
                // height: heightModal,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: widget.speeds
                        .map((e) => InkWell(
                              onTap: () {
                                onPressItem(e);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Opacity(
                                        opacity: selected == e ? 1 : 0,
                                        child: Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      e.toString() + "x",
                                      style: TextStyle(
                                          fontSize:
                                          selected == e ? 18 : 16,
                                          color: selected == e
                                              ? Colors.black
                                              : Colors.grey),
                                    )),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
