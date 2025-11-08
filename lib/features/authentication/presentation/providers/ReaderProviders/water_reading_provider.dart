// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class WaterReadingProvider extends ChangeNotifier {
//   final TextEditingController readingController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   File? _meterPhoto;
//   bool _isSaving = false;
//
//   // ✅ Getters
//   File? get meterPhoto => _meterPhoto;
//   bool get isSaving => _isSaving;
//   String get reading => readingController.text;
//   String get notes => notesController.text;
//
//   // ✅ Setters
//   set meterPhoto(File? value) {
//     _meterPhoto = value;
//     notifyListeners();
//   }
//
//   set isSaving(bool value) {
//     _isSaving = value;
//     notifyListeners();
//   }
//
//   // ✅ Pick image using camera
//   Future<void> pickPhoto() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 70,
//     );
//     if (pickedFile != null) {
//       meterPhoto = File(pickedFile.path);
//     }
//   }
//
//   // ✅ Save logic
//   Future<void> saveReading(BuildContext context, {bool offline = false}) async {
//     if (reading.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter the meter reading.')),
//       );
//       return;
//     }
//
//     isSaving = true;
//
//     await Future.delayed(const Duration(seconds: 1));
//
//     isSaving = false;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           offline
//               ? 'Meter reading saved offline successfully!'
//               : 'Meter reading saved & synced successfully!',
//         ),
//       ),
//     );
//   }
//
//   void initializeReading(String? initialValue) {
//     readingController.text = initialValue ?? '';
//   }
//
//   @override
//   void dispose() {
//     readingController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../api/service.dart';

class WaterReadingProvider extends ChangeNotifier {
  final readingController = TextEditingController();
  final notesController = TextEditingController();
  File? meterPhoto;
  bool isSaving = false;

  void initializeReading(String value) {
    readingController.text = value;
  }

  void pickPhoto() {
    // implement photo picker logic
    // assign to meterPhoto
    notifyListeners();
  }

  Future<void> saveReading(
    BuildContext context, {
    bool offline = false,
    required String meterNumber,
    required String readerCode,
  }) async {
    if (offline) {
      // save locally
      return;
    }

    if (readingController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter the reading')));
      return;
    }

    isSaving = true;
    notifyListeners();

    try {
      final payload = {
        'readerCode': readerCode,
        'meterNumber': meterNumber,
        'currentReading': readingController.text,
        'notes': notesController.text,
        'img': meterPhoto != null
            ? base64Encode(meterPhoto!.readAsBytesSync())
            : null,
      };

      final response = await ApiService.post('/reader/reading/submit', payload);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading submitted successfully')),
        );
        readingController.clear();
        notesController.clear();
        meterPhoto = null;
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Failed to submit reading');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
