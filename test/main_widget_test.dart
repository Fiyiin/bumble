import 'package:bumble/home_screen.dart';
import 'package:bumble/main.dart';
import 'package:bumble/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('finds NavigationHandler()', (WidgetTester tester) async {
    final homeWidget = NavigationHandler();

    await tester.pumpWidget(
      MaterialApp(
        home: homeWidget,
      ),
    );

    expect(find.byWidget(homeWidget), findsOneWidget);
    expect(find.byKey(Key('PageView')), findsOneWidget);
    expect(find.widgetWithText(Center, 'Profile'), findsNothing);
    expect(find.widgetWithText(Center, 'Chat'), findsNothing);
    expect(
      find.ancestor(
        of: find.byType(HomeScreen),
        matching: find.byKey(
          Key('PageView'),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('finds the bottomNavBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NavigationHandler()));

    expect(find.widgetWithText(BottomNavigationBar, 'Profile'), findsOneWidget);
    expect(find.widgetWithText(BottomNavigationBar, 'Home'), findsOneWidget);
    expect(find.widgetWithText(BottomNavigationBar, 'Chat'), findsOneWidget);
  });
}
