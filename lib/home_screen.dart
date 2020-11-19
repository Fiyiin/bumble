import 'package:bumble/utils.dart';
import 'package:bumble/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum SwipeDirection { left, right }

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<Offset> moveRight;
  Animation<Offset> moveLeft;
  AnimationController _controller;

  List<Widget> dislikedCards = <ImageCard>[];
  List<Widget> imageCards = <ImageCard>[
    ImageCard(
      picturPath: 'girl_1',
      name: 'Jessie',
      age: '22',
      bio: 'Model at Vanity Fair and Earth wanderer',
    ),
    ImageCard(
      picturPath: 'girl_2',
      name: 'Letitia',
      age: '27',
      bio: 'Professional Photographer at Nature',
    ),
    ImageCard(
      picturPath: 'girl_3',
      name: 'Melisa',
      age: '23',
      bio: '',
    ),
    ImageCard(
      picturPath: 'girl_4',
      name: 'Bianca',
      age: '26',
      bio: 'Fitness Instructor, YouTube & Peleton Content Creator',
    ),
    ImageCard(
      picturPath: 'girl_5',
      name: 'Tisa',
      age: '31',
      bio: 'Sac State 2018',
    ),
    ImageCard(
      picturPath: 'girl_6',
      name: 'Rosie',
      age: '24',
      bio: 'Cyber Security Analyst',
    ),
  ];

  SwipeDirection swipeDirection = SwipeDirection.right;

  bool _leftVisibility = false;
  bool _rightVisibility = false;

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Widget handleSwipe(Widget child) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          if (imageCards.isNotEmpty) {
            setState(() {
              swipeDirection = SwipeDirection.right;
              _rightVisibility = true;
            });
            _playAnimation();
          }
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          if (imageCards.isNotEmpty) {
            setState(() {
              swipeDirection = SwipeDirection.left;
              _leftVisibility = true;
            });
            _playAnimation();
          }
        }
      },
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
        curve: Interval(0.2, 0.5, curve: Curves.ease),
      ),
    );
    moveRight = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5, curve: Curves.ease),
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

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.favorite,
            size: 25,
            color: Color(0xff979797),
          ),
          Column(
            children: [
              Text(
                'bumble',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          SizedBox(
            child: buildSvgIcon('filter'),
          ),
        ],
      ),
    );
  }
}

class FlowAnimationDelegate extends FlowDelegate {
  FlowAnimationDelegate({
    this.rotateAnimation,
    this.translateAnimation,
    this.ctx,
    this.imageCards,
  }) : super(repaint: translateAnimation);

  final Animation<double> rotateAnimation;
  final Animation<double> translateAnimation;
  final BuildContext ctx;
  final List<ImageCard> imageCards;

  @override
  bool shouldRepaint(FlowAnimationDelegate oldDelegate) {
    return translateAnimation != oldDelegate.translateAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double width = 0.0;
    if (rotateAnimation.status == AnimationStatus.forward) {
      // return;
    }
    for (int i = 0; i < context.childCount; ++i) {
      width = MediaQuery.of(ctx).size.width;
      // number of elements in the array, counting from 0
      int elemsInArray = (context.childCount - 1);
      if (rotateAnimation.status == AnimationStatus.forward) {
        // return;
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
            i != elemsInArray ? 0 : width * translateAnimation.value, 0, 0)
          ..setRotationZ(
            i != elemsInArray ? 0 : rotateAnimation.value * math.pi / 6,
          ),
      );
    }
  }
}

class SwipeAnimation extends StatelessWidget {
  final List<ImageCard> cards;
  final AnimationController controller;
  final Animation<double> angle;
  final Animation<double> translation;
  final Animation<double> opacity;
  final SwipeDirection direction;

  SwipeAnimation({Key key, this.controller, this.cards, this.direction})
      : angle = Tween<double>(
          begin: 0.0,
          end: direction == SwipeDirection.left ? -math.pi / 6 : math.pi / 6,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.ease),
          ),
        ),
        translation = Tween<double>(
          begin: 0.0,
          end: direction == SwipeDirection.left ? -1.5 : 1.5,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.ease),
          ),
        ),
        opacity = Tween<double>(
          begin: 0.0,
          end: 1.5,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.ease),
          ),
        ),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Flow(
      delegate: FlowAnimationDelegate(
        ctx: context,
        rotateAnimation: angle,
        translateAnimation: translation,
      ),
      children: cards.map<Widget>((imageCard) => imageCard).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(direction);
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
