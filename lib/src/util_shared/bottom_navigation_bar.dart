import 'package:flutter/material.dart';
import 'package:myapp/src/constants/styling/styles.dart';
import 'package:myapp/src/features/entry_pages/moods_entry/moods_entry_screen.dart';

import '../features/analytics/anlytic_screen.dart';
//import '../features/entry_pages/moods_entry/pressentation/moodlogscreen.dart';
import '../features/calendar/calendar.dart';
import '../features/entry_pages/presentations.dart';
import '../features/entry_pages/refrection_entries/presentation/refrections_entry_page.dart';
import '../features/entry_pages/refrection_entries/presentation/refrections_view.dart';

class BottomNavBarV2 extends StatefulWidget {
  const BottomNavBarV2({super.key});

  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isDialOpen = false;
  AnimationController? _animationController;

  final List<Widget> pages = [
    const EntryListPage1(),

    //const HomeScreen(),
    const AnalyticsScreen(),
    const MyHomePage( title: 'Calendar'),
     ViewEntriesPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void setBottomBarIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void toggleDial() {
    setState(() {
      isDialOpen = !isDialOpen;
      if (isDialOpen) {
        _animationController?.forward();
      } else {
        _animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Mystyles.mybackgroundColor,
      body: Stack(
        children: [
          pages[currentIndex],
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: GestureDetector(
                      onTap: toggleDial,
                      child: AnimatedBuilder(
                        animation: _animationController!,
                        builder: (context, child) => FloatingActionButton(
                          backgroundColor: Colors.orange,
                          onPressed: toggleDial,
                          child: Icon(isDialOpen ? Icons.close : Icons.add),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                          ),
                          splashColor: Mystyles.mybottomNavigationBarColor,
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(1);
                          },
                        ),
                        SizedBox(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(2);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings_accessibility,
                            color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(3);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDialOpen)
            Positioned(
              bottom: 100,
              right: size.width / 2 - 90, // Adjusted to center the row of buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.mood),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MoodsPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.print),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ReflectionsPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.map),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) =>   EntriesPage()),
                      // );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Mystyles.mybottomNavigationBarColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(
      Offset(size.width * 0.60, 20),
      radius: const Radius.circular(20.0),
      clockwise: false,
    );
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}



class MoodTrackerScreen extends StatelessWidget {
  const MoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mystyles.myappBarColor,
        title: const Text("Mood Tracker"),
      ),
      body: const Center(
        child: Text("This is the Mood Tracker Page"),
      ),
    );
  }
}




class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: const Center(
        child: Text("This is the Map Page"),
      ),
    );
  }
}

