import 'package:flutter/material.dart';
import 'package:overlay_ex/pages/position_based_overlay.dart';
import 'package:overlay_ex/pages/simple_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    SimpleOverlay(),
    PositionBasedOverlay(),
    Container(color: Colors.amber),
  ];
  late int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Overlay Test'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(child: _pages[selectedIndex]),
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              currentIndex: selectedIndex,
              onTap: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },

              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Theme.of(context).colorScheme.surfaceDim,
              unselectedFontSize: 10,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              selectedFontSize: 10,

              items: [
                BottomNavigationBarItem(
                  label: 'Simple',
                  icon: Icon(Icons.looks_one_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Simple',
                  icon: Icon(Icons.looks_two_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Simple',
                  icon: Icon(Icons.looks_3_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
