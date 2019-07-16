import 'package:flutter/material.dart';

class NoScalingAnimation extends FloatingActionButtonAnimator{
  double _x;
  double _y;
  
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {

    return Offset(end.dx,end.dy);
  }
  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 0, end: 1).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1, end: 1 ).animate(parent);
  }
  @override
  double getAnimationRestart(double previousValue) {
    // TODO: implement getAnimationRestart
    return 1;
  }
}