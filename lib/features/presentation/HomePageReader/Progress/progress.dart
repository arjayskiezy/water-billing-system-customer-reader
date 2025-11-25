import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/LoginProvider/auth_provider.dart';
import '../../../providers/ReaderProviders/reader_dashboard_provider.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

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
    final dashboardProvider = Provider.of<ReaderDashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Overview'),
        centerTitle: true,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final readerId = authProvider.userId ?? 0;
          await dashboardProvider.refreshDashboard(readerId);
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // <- ensures pull works even if content is short
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildStatsRow(theme, dashboardProvider),
              const SizedBox(height: 30),
              _buildProgressCard(theme, dashboardProvider.completionRate),
            ],
          ),
        ),
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
}
