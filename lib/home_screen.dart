import 'package:bumble/swipe_animation.dart';
import 'package:bumble/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<Offset> moveRight;
  Animation<Offset> moveLeft;
  AnimationController _controller;

  List<Widget> dislikedCards = <ImageCard>[];
  List<Widget> imageCards = <ImageCard>[
    ImageCard(
      picturePath: 'girl_1',
      name: 'Jessie',
      age: '22',
      bio: 'Model at Vanity Fair and Earth wanderer',
    ),
    ImageCard(
      picturePath: 'girl_2',
      name: 'Letitia',
      age: '27',
      bio: 'Professional Photographer at Nature',
    ),
    ImageCard(
      picturePath: 'girl_3',
      name: 'Melisa',
      age: '23',
      bio: '',
    ),
    ImageCard(
      picturePath: 'girl_4',
      name: 'Bianca',
      age: '26',
      bio: 'Fitness Instructor, YouTube & Peleton Content Creator',
    ),
    ImageCard(
      picturePath: 'girl_5',
      name: 'Tisa',
      age: '31',
      bio: 'Sac State 2018',
    ),
    ImageCard(
      picturePath: 'girl_6',
      name: 'Rosie',
      age: '24',
      bio: 'Cyber Security Analyst',
    ),
  ];

  SwipeDirection swipeDirection = SwipeDirection.none;

  bool _leftVisibility = false;
  bool _rightVisibility = false;
  Offset initialOffset = Offset(0, 0);

  void _playAnimation() {
    _controller.forward();
  }

  Widget handleSwipe(Widget child) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onHorizontalDragStart: (details) {
        initialOffset = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        // get dx of the horizontal drag as distance moved across
        // the screen
        final swipeOffset = details.globalPosition.dx - initialOffset.dx;

        // if x is negative
        if (-swipeOffset > screenWidth / 5 && swipeOffset < 0) {
          swipeDirection = SwipeDirection.left;
        } else if (swipeOffset > screenWidth / 5 && swipeOffset > 0) {
          swipeDirection = SwipeDirection.right;
        } else {
          swipeDirection = SwipeDirection.none;
        }
      },
      onHorizontalDragEnd: (details) {
        if (swipeDirection == SwipeDirection.left) {
          setState(() {
            _leftVisibility = true;
          });
          _playAnimation();
        } else if (swipeDirection == SwipeDirection.right) {
          setState(() {
            _rightVisibility = true;
          });
          _playAnimation();
        }
      },
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        imageCards.removeLast();
        setState(() {
          _leftVisibility = false;
          _rightVisibility = false;
        });
      }
    });
    moveLeft = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5, curve: Curves.linear),
      ),
    );
    moveRight = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
            top: 16,
          ),
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Header(),
                    SizedBox(height: 10),
                    BumbleBar(
                      width: 150,
                      color: Colors.amber,
                      foregroundColor: Color(0xffF2F2F2),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                top: 50,
                child: handleSwipe(
                  SwipeAnimation(
                    controller: _controller.view,
                    cards: imageCards,
                    direction: swipeDirection,
                  ),
                ),
              ),
              Visibility(
                visible: _leftVisibility,
                child: SlideTransition(
                  position: moveLeft,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: SvgPicture.asset(
                        'asset/images/x.svg',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _rightVisibility,
                child: SlideTransition(
                  position: moveRight,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: SvgPicture.asset(
                        'asset/images/check.svg',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
