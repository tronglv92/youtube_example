import 'package:flutter/material.dart';

class TabItem extends StatefulWidget {
  TabItem(
      {this.selected,
      @required this.iconDataOn,
      this.iconDataOff,
      this.title,
      @required this.callbackFunction,
      this.middle = false});

  final String title;
  final IconData iconDataOn;
  final IconData iconDataOff;

  final bool selected;
  final Function callbackFunction;
  final bool middle;

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(TabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.middle == false
          ? Container(

              child: MaterialButton(
                onPressed: () {
                  widget.callbackFunction();
                },
                color: Colors.white,

                elevation: 0,
                padding: EdgeInsets.zero,
                highlightElevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.selected == true
                          ? widget.iconDataOn
                          : widget.iconDataOff,
                      size: 25,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      maxLines: 1,
                    )
                  ],
                ),
                // shape: CircleBorder(),
              ),
            )
          : GestureDetector(
              onTap: () {
                widget.callbackFunction();
              },
              child: Icon(
                widget.iconDataOn,
                size: 50,
              ),
            ),
    );
  }
}
