import 'package:bumble/home_screen.dart';
import 'package:bumble/utils.dart';
import 'package:flutter/material.dart';

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
            icon: buildSvgIcon('profile', color: 0xffD8D8D8),
            activeIcon: buildSvgIcon('profile', color: 0xff979797),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: buildSvgIcon('home', color: 0xffD8D8D8),
            activeIcon: buildSvgIcon('home', color: 0xff979797),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: buildSvgIcon('chat', color: 0xffD8D8D8),
            activeIcon: buildSvgIcon('chat', color: 0xff979797),
            title: Text('Chat'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: buildPageView(),
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
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (int index) {
        pageChanged(index);
      },
      children: <Widget>[
        DummyScreens('Profile'),
        HomeScreen(),
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
