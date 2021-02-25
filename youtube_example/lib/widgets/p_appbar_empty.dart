import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'p_material.dart';


class PAppBarEmpty extends StatelessWidget {
  const PAppBarEmpty({@required this.child, Key key,this.backgroundColor=Colors.white}) : super(key: key);

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {

    return PMaterial(
      child: Scaffold(
        backgroundColor: backgroundColor ,
        appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: AppBar(
            elevation: 0,

          ),
        ),
        body: SafeArea(
          bottom: false,
          child: child,
        ),
      ),
    );
  }
}