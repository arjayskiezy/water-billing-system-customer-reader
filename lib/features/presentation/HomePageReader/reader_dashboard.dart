import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LoginProvider/auth_provider.dart';
import '../../providers/ReaderProviders/reader_dashboard_provider.dart';
import 'AssignedArea/assigned_area.dart';
import 'SettingsProfile/settings_profile.dart';
import 'Progress/progress.dart';

class ReaderDashboardPage extends StatefulWidget {
  const ReaderDashboardPage({super.key});

  @override
  State<ReaderDashboardPage> createState() => _ReaderDashboardPageState();
}

class _ReaderDashboardPageState extends State<ReaderDashboardPage> {
  int _currentIndex = 0;

// Replace these placeholders with your actual pages
late final List<Widget> _pages;

@override
void initState() {
  super.initState();

  _pages = [
    const AssignedAreaPage(), 
    const ProgressPage(),     
    const SettingsPage(),     
  ];

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<ReaderDashboardProvider>(context, listen: false)
        .loadDashboardStats();
  });
}


  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning ☀️";
    if (hour < 18) return "Good afternoon 🌤️";
    return "Good evening 🌙";
  }

  BoxDecoration _threeDBox(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(3, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          offset: const Offset(-3, -3),
          blurRadius: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<ReaderDashboardProvider>(context);

    final now = DateTime.now();
    final time = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
    final day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][now.weekday % 7];
    final date = "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}";

    final fullName =
        "${authProvider.firstName ?? ''} ${authProvider.lastName ?? ''}".trim();
    final readerCode = authProvider.readerCode ?? "Unknown ReaderCode";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'gripometer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        backgroundColor: Colors.grey.shade100,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Keep Header Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: _buildHeaderCard(
                    theme,
                    fullName,
                    readerCode,
                    time,
                    date,
                    day,
                  ),
                ),
                // Expanded tab content
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Areas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Keep your header card intact
  Widget _buildHeaderCard(
    ThemeData theme,
    String fullName,
    String readerCode,
    String time,
    String date,
    String day,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Text(
                  fullName.isNotEmpty
                      ? fullName
                          .split(" ")
                          .map((e) => e[0])
                          .take(2)
                          .join()
                          .toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greetingMessage(),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    fullName.isNotEmpty ? fullName : "Reader User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    readerCode,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                day,
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


