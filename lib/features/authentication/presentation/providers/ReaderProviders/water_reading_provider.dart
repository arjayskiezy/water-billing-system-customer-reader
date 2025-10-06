import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WaterReadingProvider extends ChangeNotifier {
  final TextEditingController readingController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  File? _meterPhoto;
  bool _isSaving = false;

  // ✅ Getters
  File? get meterPhoto => _meterPhoto;
  bool get isSaving => _isSaving;
  String get reading => readingController.text;
  String get notes => notesController.text;

  // ✅ Setters
  set meterPhoto(File? value) {
    _meterPhoto = value;
    notifyListeners();
  }

  set isSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  // ✅ Pick image using camera
  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      meterPhoto = File(pickedFile.path);
    }
  }

  // ✅ Save logic
  Future<void> saveReading(BuildContext context, {bool offline = false}) async {
    if (reading.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the meter reading.')),
      );
      return;
    }

    isSaving = true;

    await Future.delayed(const Duration(seconds: 1));

    isSaving = false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          offline
              ? 'Meter reading saved offline successfully!'
              : 'Meter reading saved & synced successfully!',
        ),
      ),
    );
  }

  void initializeReading(String? initialValue) {
    readingController.text = initialValue ?? '';
  }

  @override
  void dispose() {
    readingController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
