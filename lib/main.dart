import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';
import 'package:liverify_disease_detection/screens/Ai_chatbot/generative_text_view.dart';
import 'package:liverify_disease_detection/screens/home_screen/Home_screen.dart';

import 'package:liverify_disease_detection/screens/profile_screen/profile_screen.dart';
import 'package:liverify_disease_detection/screens/splash_screen/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: Liverify_Disease_detection()));
}

class Liverify_Disease_detection extends StatefulWidget {
  const Liverify_Disease_detection({super.key});

  @override
  State<Liverify_Disease_detection> createState() =>
      _Liverify_Disease_detectionState();
}

class _Liverify_Disease_detectionState
    extends State<Liverify_Disease_detection> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          home: Splashscreen(),
        );
      },
    );
  }
}

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({super.key});

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 54.h,
        onDestinationSelected: (int index) {
          print("Nothing");
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.teal,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: whiteColor),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Image(height: 27, image: AssetImage('assets/ai_icon.png')),
            label: 'Ai Chatbot',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: whiteColor),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home page
            HomeScreen(),

            /// Notifications page
            ChatView(),

            /// Messages page
            ProfileScreen(),
          ][currentPageIndex],
    );
  }
}
