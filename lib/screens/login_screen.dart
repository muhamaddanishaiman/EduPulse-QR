import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // ===== MOCK login function (Phase 1) =====
  // Simulate a server response. Later we'll replace this with a real HTTP call.
  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate delay

    // simple mock logic:
    if (email == 'teacher@edu.com' && password == '123456') {
      return {
        'status': true,
        'token': 'mock_teacher_token_abc123',
        'user': {
          'id': 10,
          'name': 'Cikgu Faiz',
          'email': email,
          'role': 'teacher',
        }
      };
    } else if (email == 'parent@edu.com' && password == '123456') {
      return {
        'status': true,
        'token': 'mock_parent_token_def456',
        'user': {
          'id': 20,
          'name': 'Ibu Aida',
          'email': email,
          'role': 'parent',
        }
      };
    }

    // invalid credentials
    return {
      'status': false,
      'message': 'Emel atau kata laluan salah',
    };
  }
  // ===== end mock =====

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila masukkan emel dan kata laluan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await mockLogin(email, password);

      if (response['status'] == true) {
        // store token + basic user info locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token'] as String);
        await prefs.setString('role', response['user']['role'] as String);
        await prefs.setString('name', response['user']['name'] as String);

        final role = response['user']['role'] as String;
        final name = response['user']['name'] as String;

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selamat datang, $name')),
        );

        if (role == 'teacher') {
          Navigator.pushReplacementNamed(context, '/teacher_dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/parent_dashboard');
        }
      } else {
        final msg = response['message'] ?? 'Gagal log masuk';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ralat: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "EduPulse QR",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Log Masuk Guru / Ibu Bapa",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // medan emel
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Emel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // medan kata laluan
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Laluan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // butang log masuk
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Log Masuk',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}