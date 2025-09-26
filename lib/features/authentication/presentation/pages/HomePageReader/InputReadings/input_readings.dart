import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WaterReadingPage extends StatefulWidget {
  final String areaName;
  final bool isEditing;

  const WaterReadingPage({
    super.key,
    required this.areaName,
    required this.isEditing,
  });

  @override
  State<WaterReadingPage> createState() => _WaterReadingPageState();
}

class _WaterReadingPageState extends State<WaterReadingPage> {
  late TextEditingController _readingController;
  final TextEditingController _notesController = TextEditingController();
  File? _meterPhoto;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _readingController = TextEditingController(
      text: widget.isEditing ? '1,234' : '',
    );
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _meterPhoto = File(pickedFile.path);
      });
    }
  }

  void _saveReading({bool offline = false}) {
    if (_readingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the meter reading.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            offline
                ? 'Meter reading saved offline successfully!'
                : 'Meter reading saved & synced successfully!',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit Reading: ${widget.areaName}'
              : 'Add Reading: ${widget.areaName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.areaName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Magallanes Street',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Previous Reading: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: widget.isEditing ? '1,234 m³' : '-',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Current Reading
            TextField(
              controller: _readingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Current Reading',
                labelStyle: TextStyle(color: colors.primary),
                hintText: 'Enter Meter Reading (e.g., 12,345)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary),
                ),
                prefixIcon: Icon(Icons.water_drop, color: colors.primary),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Meter Photo
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: _meterPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_meterPhoto!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: colors.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Take Photo\nCapture meter display for verification',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(color: colors.primary),
                hintText: 'Add any observations, issues, or comments...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save & Sync Button
            ElevatedButton(
              onPressed: _isSaving ? null : () => _saveReading(offline: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary, // Blue background
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save & Sync',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            // Save Offline Button
            ElevatedButton(
              onPressed: _isSaving ? null : () => _saveReading(offline: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.primary), // Blue border
                ),
                elevation: 2,
              ),
              child: _isSaving
                  ? CircularProgressIndicator(color: colors.primary)
                  : Text(
                      'Save Offline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary, // Blue text
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _readingController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
