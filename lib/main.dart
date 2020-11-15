import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bumble',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          canvasColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: NavigationHandler());
  }
}

class NavigationHandler extends StatefulWidget {
  @override
  _NavigationHandlerState createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  final _controller = PageController(initialPage: 0, keepPage: true);
  int _navbarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 20,
        currentIndex: _navbarIndex,
        onTap: (index) {
          navbartapped(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: buildNavbarIcon('profile', 0xffD8D8D8),
            activeIcon: buildNavbarIcon('profile', 0xff979797),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: buildNavbarIcon('home', 0xffD8D8D8),
            activeIcon: buildNavbarIcon('home', 0xff979797),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: buildNavbarIcon('chat', 0xffD8D8D8),
            activeIcon: buildNavbarIcon('chat', 0xff979797),
            title: Text('Chat'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: buildPageView(),
    );
  }

  SvgPicture buildNavbarIcon(String path, int color) {
    return SvgPicture.asset(
      'asset/images/$path.svg',
      color: Color(color),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _navbarIndex = index;
    });
  }

  void navbartapped(int index) {
    setState(() {
      _navbarIndex = index;
      _controller.jumpToPage(index);
    });
  }

  PageView buildPageView() {
    return PageView(
      controller: _controller,
      onPageChanged: (int index) {
        pageChanged(index);
      },
      children: <Widget>[
        DummyScreens('Profile'),
        DummyScreens('Home'),
        DummyScreens('Chat'),
      ],
    );
  }
}

class DummyScreens extends StatelessWidget {
  final String title;

  DummyScreens(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 40,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
