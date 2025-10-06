import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider/auth_provider.dart';
import '../../providers/ReaderProviders/progress_provider.dart';
import './AssignedArea/assigned_area.dart';
import './SettingsProfile/settings_profile.dart';

class ReaderDashboardPage extends StatelessWidget {
  const ReaderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<ReaderDashboardProvider>(context);

    // Mocked time/date for now
    const time = "08:30 PM";
    const day = "Tuesday";
    const date = "09/23/25";

    final String fullName =
        "${authProvider.firstName ?? ''} ${authProvider.lastName ?? ''}".trim();
    final String uid = authProvider.uid ?? "Unknown UID";

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Row(
          children: [
            const SizedBox(width: 5),
            Text("gripometer", style: theme.textTheme.displayLarge),
          ],
        ),
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile + greeting
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: theme.primaryColor,
                                    child: Text(
                                      '${(authProvider.firstName ?? '').isNotEmpty ? authProvider.firstName![0].toUpperCase() : ''}'
                                      '${(authProvider.lastName ?? '').isNotEmpty ? authProvider.lastName![0].toUpperCase() : ''}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fullName.isNotEmpty
                                            ? fullName
                                            : "Reader User",
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(fontSize: 12),
                                      ),
                                      Text(
                                        'UID: $uid',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(fontSize: 12),
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
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    date,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    day,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Online & Sync status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.wifi,
                                      color: dashboardProvider.isOnline
                                          ? Colors.green
                                          : Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dashboardProvider.isOnline
                                          ? "Online"
                                          : "Offline",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sync,
                                      color: Colors.blue,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(dashboardProvider.syncStatus),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stat cards (dynamic)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        "Remaining",
                        dashboardProvider.remaining.toString(),
                        theme,
                      ),
                      _buildStatCard(
                        "Completed",
                        dashboardProvider.completed.toString(),
                        theme,
                      ),
                      _buildStatCard(
                        "Assigned",
                        dashboardProvider.assigned.toString(),
                        theme,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progress (dynamic)
                  _buildProgressCard(theme, dashboardProvider.completionRate),

                  const SizedBox(height: 16),

                  // Action cards (unchanged)
                  _buildActionCard(
                    context,
                    theme,
                    icon: Icons.work_outline,
                    title: "Field Operations",
                    description: "Manage your daily field activities",
                    actions: ["View Assignments"],
                  ),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    context,
                    theme,
                    icon: Icons.settings_outlined,
                    title: "Settings & Profile",
                    description: "Manage account preferences settings",
                    actions: ["Account Preferences"],
                  ),
                ],
              ),
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          border: const Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Offline Data Storage Available",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dashboardProvider.syncStatus,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dashboardProvider.refreshMockData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Sync Now"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, ThemeData theme) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme, double progress) {
    final percent = (progress * 100).toStringAsFixed(0);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: theme.primaryColor, size: 26),
                const SizedBox(width: 8),
                Text(
                  "Today's Progress",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("Completion Rate", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Text("$percent%"),
              ],
            ),
            const SizedBox(height: 12),
            Text("Completed ${(progress * 15).round()} of 15 readings"),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required List<String> actions,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 36, color: theme.primaryColor),
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
                  const SizedBox(height: 8),
                  Text(description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: actions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (action == "View Assignments") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AssignedAreaPage(),
                                ),
                              );
                            }

                            if (action == "Account Preferences") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsPage(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  action,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
