import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_teacher_screen.dart';

void main() {
  runApp(const EduPulseApp());
}

class EduPulseApp extends StatelessWidget {
  const EduPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPulse QR',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/teacher_dashboard': (context) => const DashboardPage(),
        '/parent_dashboard': (context) => Scaffold(
              appBar: AppBar(title: const Text('Halaman Ibu Bapa')),
              body: const Center(child: Text('Selamat datang, Ibu Bapa!')),
            ),
      },
    );
  }
}
