import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/auth_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './BillingHistory/billing_history.dart';
import './Usage/usage.dart';
import './Announcements/announcement.dart';
import '../LoginPage/login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'gripometer',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false, // makes sure it's left-aligned on all platforms
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Profile Card ---
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 12),
                    // Text Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${authProvider.firstName} ${authProvider.lastName}',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Account #: ${authProvider.accountNumber}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.wifi, color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Logout button
                    IconButton(
                      onPressed: () async {
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
            ),
            // --- Current Amount Due (dummy, you can bind with provider later) ---
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Title Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Amount Due',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    // --- Amount with Icon ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₱2840.50 PHP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          LucideIcons.coins,
                          size: 55, // bigger coins
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    Text(
                      'Due: September 25, 2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // --- Two Action Cards ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150, // 👈 fixed height for both cards
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BillingHistoryPage(), // 👈 page 1
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 👈 centers nicely
                            children: [
                              Icon(
                                LucideIcons.clock,
                                size: 32,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Billing History',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Last 15 months',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 150, // 👈 same fixed height for symmetry
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BillBreakdownPage(), // 👈 page 1
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 👈 centers nicely
                            children: [
                              Icon(
                                LucideIcons.droplets,
                                size: 32,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Usage',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                '452.324 m³',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Last Month',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // --- News & Announcements ---
            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                title: const Text(
                  'News and Announcements',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementPage(), // 👈 page 1
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // --- Images Row ---
            CarouselSlider(
              options: CarouselOptions(
                height: 160, // adjust height
                autoPlay: true, // auto slide
                enlargeCenterPage: true, // zoom effect on center
                viewportFraction: 0.8, // controls visible width per item
              ),
              items:
                  [
                    'assets/images/announcement1.jpg',
                    'assets/images/announcement2.jpg',
                    'assets/images/announcement3.jpg',
                  ].map((path) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
