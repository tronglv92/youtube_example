import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
class PhysicsAnimation extends StatefulWidget {
  @override
  _PhysicsAnimationState createState() => _PhysicsAnimationState();
}

class _PhysicsAnimationState extends State<PhysicsAnimation> with SingleTickerProviderStateMixin{

  // Animation<double> _animation;

  AnimationController _controller;

  SpringSimulation simulation;
  double translationX=0;
  Animation<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();





    _controller =
    AnimationController(vsync: this, upperBound: 500, lowerBound: -500)
      ..addListener(() {

        setState(() {
          translationX=_animation.value;
        });
      });


  }

  void runAnimation(Offset pixelsPerSecond,Size size){
    // simulation = SpringSimulation(
    //   SpringDescription(
    //     damping: 100,
    //     mass: 1,
    //     stiffness: 100,
    //   ),
    //   translationX, // starting point
    //   0, // ending point
    //   0.1, // velocity
    // );
    // _controller.animateWith(simulation);
    _animation=_controller.drive(Tween(begin: translationX,end: 0));
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      damping: 1,
      mass: 1,
      stiffness: 100,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);



  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          left: translationX,
          top: 100,
          height: 100,
          width: 100,
          child: GestureDetector(
            onHorizontalDragDown: (DragDownDetails details){
              _controller.stop();
            },
            onHorizontalDragUpdate: (DragUpdateDetails detail){
              setState(() {
                translationX+=detail.delta.dx;
              });

            },
            onHorizontalDragEnd: (DragEndDetails end ){
              print("onHorizontalDragEnd");
              runAnimation(end.velocity.pixelsPerSecond,size);
            },
            child: Container(
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
