import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavbar({
    required this.onTabSelected,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      notchMargin: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                onTabSelected(0);
              },
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                onTabSelected(1);
              },
              icon: Icon(
                Icons.settings,
                color: selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController? _animationController;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Widget buttonAdd() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Bottom Navbar')),
        body: Center(
          child: Text(
            'Tab $_selectedIndex Selected',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: BottomNavbar(
          onTabSelected: _onTabSelected,
          selectedIndex: _selectedIndex,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: buttonAdd(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
