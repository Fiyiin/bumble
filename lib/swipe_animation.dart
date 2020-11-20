import 'package:bumble/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

enum SwipeDirection { left, right }

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
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
