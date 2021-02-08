import 'package:flutter/material.dart';
import 'package:ninja_trips/shared/tripList.dart';
import 'package:ninja_trips/models/Trip.dart';
import 'package:ninja_trips/screens/details.dart';

class Heart extends StatefulWidget {
  Trip trip;
  Heart({ @required this.trip });

  @override
  _HeartState createState() => _HeartState(trip: trip);
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin{

  Trip trip;
  _HeartState({ @required this.trip });

  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _colorAnimation = ColorTween(
      begin: Colors.grey[400],
      end: Colors.red,
    ).animate(_curve);

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30,end:50),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50,end:30),
          weight: 50,
        ),
      ],
    ).animate(_curve);

    _controller.addListener(() {
      print(_controller.value);
      print(_colorAnimation.value);
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        setState(() {
          trip.isfav = true;
        });
      }
      if (status == AnimationStatus.dismissed){
        setState(() {
          trip.isfav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _){
        return IconButton(
          icon: Icon(
          Icons.favorite,
          color: _colorAnimation.value,
          size: _sizeAnimation.value,
          ),
          onPressed: () {
            trip.isfav ? _controller.reverse():_controller.forward();
            print(trip.isfav);
          },
        );
      },
    );
  }
}
