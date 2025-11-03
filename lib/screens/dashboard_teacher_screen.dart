import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // for charts
import 'package:shared_preferences/shared_preferences.dart';
import 'rmt_screen.dart';
import 'kedatangan_screen.dart';
import 'sahsiah_screen.dart';
// Placeholder for profile

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool loading = true;
  int totalStudents = 320;
  int totalTeachers = 24;
  int totalClasses = 12;
  double attendanceRate = 92.5;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildUtama() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, size: 40, color: Colors.indigo),
                SizedBox(width: 12),
                Text(
                  "EduPulse QR",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Welcome Message with Date
            Text(
              "Selamat Datang 👋",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard("Total Pelajar", totalStudents.toString(), Icons.people, Colors.blue),
                _buildStatCard("RMT Kehadiran", "85%", Icons.restaurant, Colors.orange),
                _buildStatCard("Rekod Sahsiah", "12 rekod", Icons.assignment, Colors.green),
                _buildStatCard("Kemas Kini", "2 minit lalu", Icons.update, Colors.purple),
              ],
            ),

            const SizedBox(height: 30),

            _buildAttendanceChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildKehadiran() => const KedatanganScreen();
  Widget _buildRMT() => const RmtScreen();
  Widget _buildSahsiah() => const SahsiahScreen();
  Widget _buildProfil() => Scaffold(
        appBar: AppBar(title: const Text('Profil')), 
        body: const Center(child: Text('Halaman Profil — akan ditambah.')),
      );

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> _pages = [
      _buildUtama(),
      _buildKehadiran(),
      _buildRMT(),
      _buildSahsiah(),
      _buildProfil(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.qr_code_2, size: 24),
            SizedBox(width: 12),
            Text('Menu Utama'),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Log Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _handleLogout(context);
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Kehadiran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'RMT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: 'Sahsiah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // Clear stored auth and navigate to login
  static Future<void> _handleLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('role');
      await prefs.remove('name');
    } catch (e) {
      // ignore errors clearing prefs
    }

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Attendance Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(color: Colors.green, value: 70, title: 'Present'),
                    PieChartSectionData(color: Colors.red, value: 20, title: 'Absent'),
                    PieChartSectionData(color: Colors.orange, value: 10, title: 'Late'),
                  ],
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
