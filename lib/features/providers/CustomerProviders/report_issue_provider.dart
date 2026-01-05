import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../api/api.dart';
import 'dart:convert';

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
  Future<void> submitIssue(BuildContext context, String accountNumber) async {
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

    try {
      final response = await ApiService.post(
        '/customer/report/create/$accountNumber',
        {'title': _selectedTitle, 'description': _description},
      );

      // 1. Dio uses 'statusCode', but usually we check if the response is successful
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue submitted successfully!')),
        );

        // Reset fields
        _selectedTitle = null;
        _description = '';
        _attachment = null;
        notifyListeners();
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _isSubmitting = false;
    notifyListeners();
  }
}
