import 'package:bumble/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImageCard extends StatelessWidget {
  final String picturePath;
  final String name;
  final String age;
  final String bio;

  const ImageCard({
    Key key,
    this.picturePath,
    this.name,
    this.age,
    this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                'asset/images/$picturePath.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0x73000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0xbf000000)
              ],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 30,
          child: buildSvgIcon('quotes'),
        ),
        Positioned(
          right: -15,
          top: 70,
          child: BumbleBar(
            angle: math.pi / 2,
            color: Colors.grey[350],
            foregroundColor: Color(0x88F2F2F2),
            width: 80,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      padding: EdgeInsets.only(top: 5),
                      child: buildSvgIcon('verified'),
                    ),
                    Text(
                      '$name,',
                      key: Key('name'),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      age,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 250,
                  child: Text(
                    bio,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black26),
                  child: Row(
                    children: [
                      Container(
                        height: 16,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: buildSvgIcon(
                          'smiley',
                          color: 0xffFFFFFF,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'React to photo',
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BumbleBar extends StatelessWidget {
  final Color color;
  final Color foregroundColor;
  final double angle;
  final double width;

  const BumbleBar({
    this.color,
    this.foregroundColor,
    this.angle = 0,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Stack(
        children: [
          Container(
            width: width,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: foregroundColor,
            ),
          ),
          Positioned(
            child: Container(
              width: width * (1 / 8),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: color,
              ),
            ),
          ),
        ],
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
