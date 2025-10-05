import 'package:flutter/material.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedTitle;

  // Predefined water issue titles
  final List<String> _issueTitles = [
    'No Water',
    'Not Clean Water',
    'Billing / Payment Error',
    'Meter Reading Error',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue'), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Instruction Card ---
            Card(
              color: colors.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Please describe the issue you are experiencing. '
                  'Our support team will review and respond as soon as possible.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Issue Title Dropdown ---
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Issue Title',
                    labelStyle: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: _selectedTitle,
                  items: _issueTitles
                      .map(
                        (title) =>
                            DropdownMenuItem(value: title, child: Text(title)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTitle = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Issue Description Field ---
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: colors.tertiary,
                      fontWeight: FontWeight.w100,
                    ),
                    hintText: 'Describe the problem in detail...',
                    hintStyle: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Optional Screenshot / Attachment Button ---
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add file picker functionality
              },
              icon: const Icon(Icons.attach_file, color: Colors.white),
              label: const Text(
                'Attach File (Optional)',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 12),

            // --- Submit Button ---
            ElevatedButton.icon(
              onPressed: () {
                if (_selectedTitle == null ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select an issue title and enter a description',
                      ),
                    ),
                  );
                  return;
                }

                // TODO: Submit the issue
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Issue submitted!')),
                );
              },
              icon: Icon(Icons.send, color: colors.primary),
              label: Text(
                'Submit Issue',
                style: TextStyle(color: colors.primary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

// --- Main entry point ---
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00539A),
          primary: const Color(0xFF00539A),
        ),
      ),
      home: const ReportIssuePage(),
    ),
  );
}
