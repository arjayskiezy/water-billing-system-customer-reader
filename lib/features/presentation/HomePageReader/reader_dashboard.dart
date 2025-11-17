import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/LoginProvider/auth_provider.dart';
import '../../providers/ReaderProviders/water_reading_provider.dart';
import '../../providers/ReaderProviders/reader_dashboard_provider.dart';
import '../../providers/ReaderProviders/storage_provider.dart';
import 'AssignedArea/assigned_area.dart';
import 'SettingsProfile/settings_profile.dart';

class ReaderDashboardPage extends StatefulWidget {
  const ReaderDashboardPage({super.key});

  @override
  State<ReaderDashboardPage> createState() => _ReaderDashboardPageState();
}

class _ReaderDashboardPageState extends State<ReaderDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard stats when page first loads (on login)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider =
          Provider.of<ReaderDashboardProvider>(context, listen: false);
      dashboardProvider.loadDashboardStats();
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
          : RefreshIndicator(
              onRefresh: () async => dashboardProvider.refreshDashboard(
                authProvider.userId ?? 0,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(
                        theme,
                        fullName,
                        readerCode,
                        time,
                        date,
                        day,
                      ),
                      const SizedBox(height: 20),
                      _buildConnectionCard(theme, dashboardProvider),
                      const SizedBox(height: 20),
                      _buildStatsRow(theme, dashboardProvider),
                      const SizedBox(height: 20),
                      _buildProgressCard(
                        theme,
                        dashboardProvider.completionRate,
                      ),
                      const SizedBox(height: 24),
                      _buildActionCard(
                        context,
                        theme,
                        icon: Icons.map_rounded,
                        title: "Field Operations",
                        description: "Monitor and manage your assigned areas.",
                        buttonText: "View Assignments",
                        onTap: () async {
                          // Navigate to AssignedAreaPage and wait for return
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AssignedAreaPage(),
                            ),
                          );
                          // When user returns, reload dashboard stats
                          if (mounted) {
                            final dashboardProvider =
                                Provider.of<ReaderDashboardProvider>(
                              context,
                              listen: false,
                            );
                            await dashboardProvider.loadDashboardStats();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        context,
                        theme,
                        icon: Icons.settings_rounded,
                        title: "Settings & Profile",
                        description:
                            "Customize your preferences and manage account details.",
                        buttonText: "Account Preferences",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildFooter(context, theme, dashboardProvider),
    );
  }

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

  Widget _buildConnectionCard(
    ThemeData theme,
    ReaderDashboardProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: _threeDBox(Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statusIconText(
            icon: Icons.wifi_rounded,
            text: provider.isOnline ? "Online" : "Offline",
            color: provider.isOnline ? Colors.green : Colors.red,
          ),
          _statusIconText(
            icon: Icons.sync_rounded,
            text: provider.syncStatus,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, ReaderDashboardProvider provider) {
    return Row(
      children: [
        _buildStatCard(
          theme,
          "Remaining",
          provider.remaining.toString(),
          Icons.pending_actions_rounded,
          Colors.orange,
        ),
        _buildStatCard(
          theme,
          "Completed",
          provider.completed.toString(),
          Icons.check_circle_rounded,
          Colors.green,
        ),
        _buildStatCard(
          theme,
          "Assigned",
          provider.assigned.toString(),
          Icons.work_rounded,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: _threeDBox(Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, double progress) {
    final percent = (progress * 100).toStringAsFixed(0);
    return Container(
      decoration: _threeDBox(Colors.white),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today_rounded, color: theme.primaryColor, size: 22),
              const SizedBox(width: 6),
              Text(
                "Today's Progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$percent% complete",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                progress >= 1.0
                    ? "🎯 Done for the day!"
                    : progress >= 0.6
                    ? "Almost there 💪"
                    : "Keep going 🚀",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  "+5% better than yesterday",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: _threeDBox(Colors.white),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.white,
                  ),
                  label: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        theme.primaryColor, // primary color background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIconText({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    ThemeData theme,
    ReaderDashboardProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sync Status",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  provider.syncStatus,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              final waterReadingProvider = Provider.of<WaterReadingProvider>(
                context,
                listen: false,
              );

              final storageProvider = Provider.of<StorageProvider>(
                context,
                listen: false,
              );

              await provider.syncNow(
                waterReadingProvider,
                storageProvider: storageProvider,
                readerId: auth.userId ?? 0,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              elevation: 5,
              shadowColor: theme.primaryColor.withOpacity(0.3),
            ),
            icon: const Icon(Icons.sync, size: 18),
            label: const Text("Sync Now"),
          ),
        ],
      ),
    );
  }
}
