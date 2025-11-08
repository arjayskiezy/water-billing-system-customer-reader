import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/ReaderProviders/water_reading_provider.dart';
import '../../../providers/AuthProvider/auth_provider.dart';

class WaterReadingPage extends StatefulWidget {
  final String areaName;
  final bool isEditing;
  final String previousReading;
  final String address;
  final String meterNumber;

  const WaterReadingPage({
    super.key,
    required this.areaName,
    required this.meterNumber,
    required this.isEditing,
    this.previousReading = '-',
    this.address = '-',
  });

  @override
  State<WaterReadingPage> createState() => _WaterReadingPageState();
}

class _WaterReadingPageState extends State<WaterReadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize reading controller empty
      context.read<WaterReadingProvider>().initializeReading('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterReadingProvider>();
    final authProvider = context.read<AuthProvider>(); // to get readerCode
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
                    Text(
                      'Address: ${widget.address}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            text: widget.previousReading != '-'
                                ? '${widget.previousReading} m³'
                                : '-',
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

            // Current Reading Input
            TextField(
              controller: provider.readingController,
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
                onTap: provider.pickPhoto,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: provider.meterPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            provider.meterPhoto!,
                            fit: BoxFit.cover,
                          ),
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

            // Notes Input
            TextField(
              controller: provider.notesController,
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
              onPressed: provider.isSaving
                  ? null
                  : () => provider.saveReading(
                      context,
                      offline: false,
                      meterNumber: widget.meterNumber,
                      readerCode:
                          authProvider.readerCode ?? '', // from AuthProvider
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              child: provider.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save & Sync',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            // Save Offline Button
            ElevatedButton(
              onPressed: provider.isSaving
                  ? null
                  : () => provider.saveReading(
                      context,
                      offline: true,
                      meterNumber: widget.meterNumber,
                      readerCode: authProvider.readerCode ?? '',
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.primary),
                ),
                elevation: 2,
              ),
              child: provider.isSaving
                  ? CircularProgressIndicator(color: colors.primary)
                  : Text(
                      'Save Offline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
