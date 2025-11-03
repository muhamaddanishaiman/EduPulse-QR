import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

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
        '/teacher_dashboard': (context) => Scaffold(
              appBar: AppBar(title: const Text('Halaman Guru')),
              body: const Center(child: Text('Selamat datang, Guru!')),
            ),
        '/parent_dashboard': (context) => Scaffold(
              appBar: AppBar(title: const Text('Halaman Ibu Bapa')),
              body: const Center(child: Text('Selamat datang, Ibu Bapa!')),
            ),
      },
    );
  }
}
