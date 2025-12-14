import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/CustomerProviders/announcement_provider.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  /// Get badge color based on type
  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'maintenance':
        return Colors.orange;
      case 'billing':
        return Colors.green;
      case 'policy':
        return Colors.purple;
      case 'alert':
        return Colors.red;
      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);

    // Fetch announcements once when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchAnnouncements();
    });

    final announcements = provider.announcements;

    Widget announcementCard(Map<String, dynamic> announcement) {
      final type = announcement['type'] ?? "";

      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                announcement['title'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              /// Type badge
              if (type.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: getTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: getTypeColor(type),
                    ),
                  ),
                ),

              /// Date
              Text(
                announcement['date'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              /// Description
              Text(
                announcement['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: announcements.isEmpty
          ? const Center(
              child: Text(
                "No announcements available.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return announcementCard(announcements[index]);
              },
            ),
    );
  }
}
