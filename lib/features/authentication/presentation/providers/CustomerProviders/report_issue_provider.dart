import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ReportIssueProvider extends ChangeNotifier {
  // --- Fields ---
  String? _selectedTitle;
  String _description = '';
  File? _attachment;
  bool _isSubmitting = false;

  // --- Getters ---
  String? get selectedTitle => _selectedTitle;
  String get description => _description;
  File? get attachment => _attachment;
  bool get isSubmitting => _isSubmitting;

  // --- Setters ---
  void setTitle(String? title) {
    _selectedTitle = title;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  // --- File Picker ---
  Future<void> pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        _attachment = File(result.files.single.path!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void removeAttachment() {
    _attachment = null;
    notifyListeners();
  }

  // --- Submit Issue ---
  Future<void> submitIssue(BuildContext context) async {
    if (_selectedTitle == null || _description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an issue title and enter a description.',
          ),
        ),
      );
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    // Simulated delay (replace with backend API call)
    await Future.delayed(const Duration(seconds: 2));

    _isSubmitting = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Issue submitted successfully!')),
    );

    // Reset fields
    _selectedTitle = null;
    _description = '';
    _attachment = null;
    notifyListeners();
  }
}
