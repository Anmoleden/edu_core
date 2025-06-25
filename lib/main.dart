import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_page.dart';
import 'screens/parents/parents_home_page.dart';
import 'screens/teachers/teachers_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parents Portal',
      theme: ThemeData(
        primaryColor: const Color(0xFFE65100),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE65100),
          secondary: Color(0xFFFF9800),
          surface: Color(0xFFFFEFC7),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE65100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFE65100),
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/parentHome': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return ParentsHomePage(
            parentName: args?['name'] ?? '',
            parentPhotoUrl: args?['photoUrl'] ?? '',
          );
        },
        '/teacherHome': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return TeachersHomePage(
            teacherName: args?['name'] ?? '',
            teacherPhotoUrl: args?['photoUrl'] ?? '',
          );
        },
      },
    );
  }
}
