import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/CustomerProviders/report_issue_provider.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportIssueProvider>(context);
    final colors = Theme.of(context).colorScheme;

    final issueTitles = [
      'No Water',
      'Not Clean Water',
      'Billing / Payment Error',
      'Meter Reading Error',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
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

            // --- Dropdown ---
            DropdownButtonFormField<String>(
              value: provider.selectedTitle,
              decoration: InputDecoration(
                labelText: 'Issue Title',
                labelStyle: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              items: issueTitles
                  .map(
                    (title) =>
                        DropdownMenuItem(value: title, child: Text(title)),
                  )
                  .toList(),
              onChanged: provider.setTitle,
            ),
            const SizedBox(height: 12),

            // --- Description Field ---
            TextField(
              onChanged: provider.setDescription,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the problem in detail...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Attachment Button ---
            ElevatedButton.icon(
              onPressed: provider.pickAttachment,
              icon: const Icon(Icons.attach_file, color: Colors.white),
              label: Text(
                provider.attachment == null
                    ? 'Attach File (Optional)'
                    : 'Attached: ${provider.attachment!.path.split('/').last}',
                style: const TextStyle(color: Colors.white),
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
              onPressed: provider.isSubmitting
                  ? null
                  : () => provider.submitIssue(context),
              icon: provider.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.send, color: colors.primary),
              label: Text(
                provider.isSubmitting ? 'Submitting...' : 'Submit Issue',
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
}
