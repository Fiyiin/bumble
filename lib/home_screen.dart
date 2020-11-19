import 'package:bumble/utils.dart';
import 'package:bumble/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum SwipeDirection { left, right }
SwipeDirection swipeDirection = SwipeDirection.right;

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
  AnimationController _rotationController;
  AnimationController _translationController;

  FlowAnimationDelegate _delegate;

  void _startAnimation() {
    // if (_translationController.isAnimating && _rotationController.isAnimating) {
    //   _translationController.stop();
    //   _rotationController.stop();
    //   return;
    // }
    _translationController.reset();
    _rotationController.reset();
    _translationController.forward();
    _rotationController.forward();
  }

  void onAnimationComplete(AnimationStatus _) {
    if (_translationController.status == AnimationStatus.completed &&
        _rotationController.status == AnimationStatus.completed) {
      imageCards.removeLast();
    }
  }

  Widget handleSwipe(Widget imageCard) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          if (imageCards.isNotEmpty) {
            setState(() {
              swipeDirection = SwipeDirection.right;
            });
            _startAnimation();
          }
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          if (imageCards.isNotEmpty) {
            setState(() {
              swipeDirection = SwipeDirection.left;
            });
            _startAnimation();
          }
        }
      },
      child: imageCard,
    );
  }

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: math.pi / 12,
      duration: Duration(milliseconds: 500),
    );

    _translationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.5,
      duration: Duration(milliseconds: 500),
    );

    _rotationController.addStatusListener(onAnimationComplete);

    _translationController.addStatusListener(onAnimationComplete);

    _delegate = FlowAnimationDelegate(
      rotateAnimation: _rotationController,
      translateAnimation: _translationController,
      ctx: context,
      imageCards: imageCards,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _translationController.dispose();
    _rotationController.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
              SizedBox(height: 10),
              Expanded(
                child: Flow(
                  delegate: _delegate,
                  children: imageCards
                      .map<Widget>((imageCard) => handleSwipe(imageCard))
                      .toList(),
                ),
              ),
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
    double dx = 0.0;
    if (rotateAnimation.status == AnimationStatus.forward) {
      // return;
    }
    for (int i = 0; i < context.childCount; ++i) {
      dx = MediaQuery.of(ctx).size.width;
      // number of elements in the array, counting from 0
      int elemsInArray = (context.childCount - 1);
      if (rotateAnimation.status == AnimationStatus.forward) {
        // return;
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
            i != elemsInArray
                ? 0
                : swipeDirection == SwipeDirection.right
                    ? dx * translateAnimation.value
                    : -dx * translateAnimation.value,
            0,
            0)
          ..setRotationZ(
            i != elemsInArray
                ? 0
                : swipeDirection == SwipeDirection.right
                    ? rotateAnimation.value * 1.5
                    : (-rotateAnimation.value),
          ),
      );
    }
  }
}
