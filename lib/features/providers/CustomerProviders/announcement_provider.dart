import 'package:flutter/foundation.dart';
import '../../api/api.dart';

class AnnouncementProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _announcements = [];

  List<Map<String, dynamic>> get announcements => _announcements;

  /// Fetch announcements from backend
  Future<void> fetchAnnouncements() async {
    try {
      final data = await ApiService.get('/customer/announcements');

      if (data is List) {
        _announcements = data.map<Map<String, dynamic>>((item) {
          String type = "";
          switch (item["type"] ?? "") {
            case "maintenance":
              type = "maintenance";
              break;
            case "general":
              type = "general";
              break;
            case "system":
              type = "system";
              break;
            default:
              type = "other";
          }

          return {
            "title": item["title"] ?? "",
            "description": item["description"] ?? "",
            "type": type,
            "date": item["published"] ?? "",
          };
        }).toList();
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching announcements: $e");
    }
  }
}
