import 'package:flutter/foundation.dart';

class AnnouncementProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'Scheduled Maintenance',
      'date': 'Sep 25, 2025',
      'description':
          'Water services will be temporarily unavailable from 10:00 AM to 2:00 PM due to scheduled maintenance.',
      'unread': false,
    },
    {
      'title': 'New Payment Options',
      'date': 'Sep 20, 2025',
      'description':
          'Soonest we accept mobile payments via GCash and PayMaya for your convenience.',
      'unread': true,
    },
    {
      'title': 'Policy Update',
      'date': 'Sep 15, 2025',
      'description':
          'The late payment fee policy has been updated. Please review your monthly statements for details.',
      'unread': true,
    },
  ];

  List<Map<String, dynamic>> get announcements => _announcements;

  void markAllAsRead() {
    for (var a in _announcements) {
      a['unread'] = false;
    }
    notifyListeners();
  }

  void markAsRead(int index) {
    _announcements[index]['unread'] = false;
    notifyListeners();
  }

  void addAnnouncement(Map<String, dynamic> newAnnouncement) {
    _announcements.insert(0, newAnnouncement);
    notifyListeners();
  }
}
