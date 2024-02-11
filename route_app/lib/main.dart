import 'package:flutter/material.dart';
import 'package:route_app/screens/aiscreen.dart';
import 'package:route_app/screens/busesscreen.dart';
import 'package:route_app/screens/homescreen.dart';
import 'package:route_app/screens/mapscreen.dart';
import 'package:route_app/screens/settingscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentPageIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    const MapScreen(),
    const AiScreen(),
    const BussesScreen(),
    const SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                    icon: Icon(Icons.home_rounded), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.map_rounded), label: 'Maps'),
                NavigationDestination(
                    icon: Icon(Icons.message_rounded), label: 'Ai'),
                NavigationDestination(
                    icon: Icon(Icons.bus_alert_rounded), label: 'Buses'),
                NavigationDestination(
                    icon: Icon(Icons.settings_rounded), label: 'Settings')
              ]),
          body: screens[currentPageIndex]),
    );
  }
}
