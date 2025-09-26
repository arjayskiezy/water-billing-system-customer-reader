import 'package:flutter/material.dart';
import '../login_page.dart';

class MoreInfoPage extends StatelessWidget {
  const MoreInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("More Information")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Why Digital Water Billing?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Traditional water billing is slow, manual, and error-prone. Our digital system modernizes the process, making it faster, more accurate, and easier to manage.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 32),

            // Features Section
            Text(
              "Key Features",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),

            FeatureTile(
              icon: Icons.desktop_windows,
              title: "Online Record Management",
              description:
                  "All meter readings, billing info, and customer records are stored securely online for easy access and auditing.",
            ),
            FeatureTile(
              icon: Icons.auto_graph,
              title: "Automatic Bill Generation",
              description:
                  "Bills are generated automatically based on meter readings, reducing human error and saving time.",
            ),
            FeatureTile(
              icon: Icons.plumbing,
              title: "Plumber-Friendly Input",
              description:
                  "Plumbers can directly encode meter readings from the field, updating records in real time.",
            ),
            FeatureTile(
              icon: Icons.analytics,
              title: "Reporting & Analytics",
              description:
                  "Generate reports, track water consumption trends, and make informed decisions for better resource management.",
            ),
            const SizedBox(height: 32),

            // Call to Action
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(), // 👈 page 1
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Apply Now",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

// Feature Tile Widget
class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.4,
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
