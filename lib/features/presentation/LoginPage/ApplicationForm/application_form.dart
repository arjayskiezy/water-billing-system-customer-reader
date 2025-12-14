import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/LoginProvider/water_application_provider.dart';
import '../login_page.dart';

class WaterApplicationFormPage extends StatelessWidget {
  const WaterApplicationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final _formKey = GlobalKey<FormState>();

    return ChangeNotifierProvider(
      create: (_) => WaterApplicationProvider(),
      child: Consumer<WaterApplicationProvider>(
        builder: (context, provider, _) {
          List<Widget> formSteps() => [
            // Step 0
            Column(
              children: [
                TextFormField(
                  initialValue: provider.email,
                  onChanged: provider.setEmail,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: provider.applicantFirstName,
                  onChanged: provider.setApplicantFirstName,
                  decoration: InputDecoration(
                    labelText: 'Applicant First Name',
                    prefixIcon: Icon(Icons.person, color: colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  initialValue: provider.applicantSecondName,
                  onChanged: provider.setApplicantSecondName,
                  decoration: InputDecoration(
                    labelText: 'Applicant Last Name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: colors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  initialValue: provider.spouseName,
                  onChanged: provider.setSpouseName,
                  decoration: InputDecoration(
                    labelText: 'Name of Spouse',
                    prefixIcon: Icon(
                      Icons.person_3_sharp,
                      color: colors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: provider.presentAddress,
                  onChanged: provider.setPresentAddress,
                  decoration: InputDecoration(
                    labelText: 'Present Address',
                    prefixIcon: Icon(Icons.home, color: colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter present address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: provider.previousAddress,
                  onChanged: provider.setPreviousAddress,
                  decoration: InputDecoration(
                    labelText: 'Previous Address',
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: colors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.nextStep();
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
                DropdownButtonFormField<String>(
                  value: provider.applicationType,
                  onChanged: (val) {
                    if (val != null) provider.setApplicationType(val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Water Application Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Residential', 'Commercial', 'Industrial']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: provider.houseMaterial,
                  onChanged: (val) {
                    if (val != null) provider.setHouseMaterial(val);
                  },
                  decoration: InputDecoration(
                    labelText: 'House/Establishment Material',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Wood', 'Concrete', 'Bamboo', 'Others']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: provider.ownershipStatus,
                  onChanged: (val) {
                    if (val != null) provider.setOwnershipStatus(val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Ownership Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Owned', 'Rented']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: provider.meterLocation,
                  onChanged: provider.setMeterLocation,
                  decoration: InputDecoration(
                    labelText: 'Meter Location',
                    prefixIcon: Icon(Icons.water_damage_rounded, color: colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter meter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: provider.meterNumber,
                  onChanged: provider.setMeterNumber,
                  decoration: InputDecoration(
                    labelText: 'Meter Number',
                    prefixIcon: Icon(Icons.numbers_sharp, color: colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Do you want interior plumbing installed?'),
                  value: provider.interiorPlumbing,
                  onChanged: provider.setInteriorPlumbing,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: provider.previousStep,
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          provider.submitForm(context);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Next Steps',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'You’ve successfully completed the first step of your water application!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Next, please visit Your Water District Department to continue your application.',
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Requirements:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        '1 Photocopy of TAX DECLARATION',
                                      ),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        '1 Photocopy of TAX RECEIPT for this year',
                                      ),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        '1 Photocopy of RESIDENCE CERTIFICATE',
                                      ),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        'BRGY. CERTIFICATION FOR WATER CONNECTION',
                                      ),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ];

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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill out the form to request a new water service account.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      formSteps()[provider.currentStep],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
