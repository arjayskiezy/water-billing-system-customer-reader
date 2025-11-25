import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/ReaderProviders/input_readings_provider.dart';
import '../../../providers/LoginProvider/auth_provider.dart';

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
  final int digitCount = 5;
  late List<TextEditingController> digitControllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    digitControllers = List.generate(
      digitCount,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(digitCount, (index) => FocusNode());

    final provider = context.read<WaterReadingProvider>();
    provider.addListener(_providerListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.initializeReadingForMeter(widget.meterNumber);
      _populateExistingReading(provider.readingController.text);
    });
  }

  void _providerListener() {
    final provider = context.read<WaterReadingProvider>();
    if (provider.readingController.text.isEmpty) {
      for (var c in digitControllers) {
        c.clear();
      }
      setState(() {}); // refresh UI
    }
  }

  void _populateExistingReading(String value) {
    if (value.isEmpty) return;

    final padded = value.padLeft(digitCount, '0');
    for (int i = 0; i < digitCount; i++) {
      digitControllers[i].text = padded[i];
    }
  }

  void _updateProviderReading() {
    final provider = context.read<WaterReadingProvider>();
    final reading = digitControllers.map((c) => c.text).join('');
    provider.readingController.text = reading;
  }

  @override
  void dispose() {
    for (var c in digitControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    context.read<WaterReadingProvider>().removeListener(_providerListener);
    super.dispose();
  }

  Widget buildDigitBox(int index, ColorScheme colors) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: digitControllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary, width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty) {
            if (index < digitCount - 1) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          }
          _updateProviderReading();
        },
        onTap: () {
          digitControllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: digitControllers[index].text.length,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterReadingProvider>();
    final authProvider = context.read<AuthProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit Reading: ${widget.meterNumber}'
              : 'Add Reading: ${widget.meterNumber}',
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
            // AREA INFO
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

            /// 5 DIGIT INPUT BOXES
            const Text(
              "Current Reading",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  digitCount,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: buildDigitBox(i, colors),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "m³",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // PHOTO
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
                          child: SizedBox.expand(
                            child: Image.file(
                              provider.meterPhoto!,
                              fit: BoxFit.cover,
                            ),
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
                              'Take Photo\nCapture meter display',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // NOTES
            TextField(
              controller: provider.notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(color: colors.primary),
                hintText: 'Add any issues or remarks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      await provider.saveReading(
                        context,
                        meterNumber: widget.meterNumber,
                        readerCode: authProvider.readerCode ?? "",
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: provider.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Save Reading",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
