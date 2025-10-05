import 'package:flutter/material.dart';

class WaterApplicationFormPage extends StatefulWidget {
  const WaterApplicationFormPage({super.key});

  @override
  State<WaterApplicationFormPage> createState() =>
      _WaterApplicationFormPageState();
}

class _WaterApplicationFormPageState extends State<WaterApplicationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _applicantController = TextEditingController();
  final TextEditingController _spouseController = TextEditingController();
  final TextEditingController _presentAddressController =
      TextEditingController();
  final TextEditingController _previousAddressController =
      TextEditingController();
  final TextEditingController _faucetLocationController =
      TextEditingController();
  final TextEditingController _additionalFaucetController =
      TextEditingController();

  // Form state
  String _applicationType = 'Residential';
  String _houseMaterial = 'Wood';
  String _ownershipStatus = 'Owned';
  bool _interiorPlumbing = false;

  // Step control
  int _currentStep = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _applicantController.dispose();
    _spouseController.dispose();
    _presentAddressController.dispose();
    _previousAddressController.dispose();
    _faucetLocationController.dispose();
    _additionalFaucetController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully!')),
      );
      // TODO: Send data to backend
    }
  }

  List<Widget> _formSteps(ColorScheme colors) => [
    // Step 0
    Column(
      children: [
        // Email
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Name of Applicant
        TextFormField(
          controller: _applicantController,
          decoration: InputDecoration(
            labelText: 'Name of Applicant',
            prefixIcon: Icon(Icons.person, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter applicant name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Name of Spouse
        TextFormField(
          controller: _spouseController,
          decoration: InputDecoration(
            labelText: 'Name of Spouse',
            prefixIcon: Icon(Icons.person_outline, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Present Address
        TextFormField(
          controller: _presentAddressController,
          decoration: InputDecoration(
            labelText: 'Present Address',
            prefixIcon: Icon(Icons.home, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter present address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Previous Address
        TextFormField(
          controller: _previousAddressController,
          decoration: InputDecoration(
            labelText: 'Previous Address',
            prefixIcon: Icon(Icons.home_outlined, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Next Button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _currentStep++;
                });
              }
            },
            child: const Text('Next'),
          ),
        ),
      ],
    ),

    // Step 1
    Column(
      children: [
        // Application Type
        DropdownButtonFormField<String>(
          value: _applicationType,
          decoration: InputDecoration(
            labelText: 'Water Application Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            'Residential',
            'Commercial',
            'Industrial',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              _applicationType = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        // House Material
        DropdownButtonFormField<String>(
          value: _houseMaterial,
          decoration: InputDecoration(
            labelText: 'House/Establishment Material',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            'Wood',
            'Concrete',
            'Bamboo',
            'Others',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              _houseMaterial = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        // Ownership Status
        DropdownButtonFormField<String>(
          value: _ownershipStatus,
          decoration: InputDecoration(
            labelText: 'Ownership Status',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            'Owned',
            'Rented',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              _ownershipStatus = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        // Faucet Location
        TextFormField(
          controller: _faucetLocationController,
          decoration: InputDecoration(
            labelText: 'Faucet Location',
            prefixIcon: Icon(Icons.water, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Additional Faucet
        TextFormField(
          controller: _additionalFaucetController,
          decoration: InputDecoration(
            labelText: 'Additional Faucet (Optional)',
            prefixIcon: Icon(Icons.add, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Interior Plumbing
        SwitchListTile(
          title: const Text('Do you want interior plumbing installed?'),
          value: _interiorPlumbing,
          onChanged: (val) {
            setState(() {
              _interiorPlumbing = val;
            });
          },
        ),
        const SizedBox(height: 24),
        // Back & Submit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () {
                // ✅ Validate before submission
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields.'),
                    ),
                  );
                }
              },
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Application Form'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  'Application Form',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill out the form to request a new water service account.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                // Show current step
                _formSteps(colors)[_currentStep],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
