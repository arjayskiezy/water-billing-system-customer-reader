import 'package:flutter/material.dart';
import '../../api/api.dart';
import 'dart:convert';

class WaterApplicationProvider extends ChangeNotifier {
  // --- Step management ---
  int _currentStep = 0;
  int get currentStep => _currentStep;

  void nextStep() {
    if (_currentStep < 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  // --- Form fields ---
  String _email = '';
  String _applicantFirstName = '';
  String _applicantSecondName = '';
  String _spouseName = '';
  String _presentAddress = '';
  String _previousAddress = '';
  String _meterLocation = '';
  String _meterNumber = '';
  bool _interiorPlumbing = false;
  String _applicationType = 'Residential';
  String _houseMaterial = 'Concrete';
  String _ownershipStatus = 'Owned';

  // --- Getters ---
  String get email => _email;
  String get applicantFirstName => _applicantFirstName;
  String get applicantSecondName => _applicantSecondName;
  String get spouseName => _spouseName;
  String get presentAddress => _presentAddress;
  String get previousAddress => _previousAddress;
  String get meterLocation => _meterLocation;
  String get meterNumber => _meterNumber;
  bool get interiorPlumbing => _interiorPlumbing;
  String get applicationType => _applicationType;
  String get houseMaterial => _houseMaterial;
  String get ownershipStatus => _ownershipStatus;

  // --- Setters ---
  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setApplicantFirstName(String value) {
    _applicantFirstName = value;
    notifyListeners();
  }

  void setApplicantSecondName(String value) {
    _applicantSecondName = value;
    notifyListeners();
  }

  void setSpouseName(String value) {
    _spouseName = value;
    notifyListeners();
  }

  void setPresentAddress(String value) {
    _presentAddress = value;
    notifyListeners();
  }

  void setPreviousAddress(String value) {
    _previousAddress = value;
    notifyListeners();
  }

  void setMeterLocation(String value) {
    _meterLocation = value;
    notifyListeners();
  }

  void setMeterNumber(String value) {
    _meterNumber = value;
    notifyListeners();
  }

  void setInteriorPlumbing(bool value) {
    _interiorPlumbing = value;
    notifyListeners();
  }

  void setApplicationType(String value) {
    _applicationType = value;
    notifyListeners();
  }

  void setHouseMaterial(String value) {
    _houseMaterial = value;
    notifyListeners();
  }

  void setOwnershipStatus(String value) {
    _ownershipStatus = value;
    notifyListeners();
  }

  // --- Submission state ---
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // --- Submit form ---
  Future<void> submitForm(BuildContext context) async {
    // Validation before submit
    if (_email.isEmpty ||
        !_email.contains('@') ||
        _applicantFirstName.isEmpty ||
        _applicantSecondName.isEmpty ||
        _presentAddress.isEmpty ||
        _meterLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/customer/application/create', {
        'email': _email,
        'applicantFirstName': _applicantFirstName,
        'applicantSecondName': _applicantSecondName,
        'spouseName': _spouseName,
        'presentAddress': _presentAddress,
        'previousAddress': _previousAddress,
        'applicationType': _applicationType,
        'houseMaterial': _houseMaterial,
        'ownershipStatus': _ownershipStatus,
        'meterLocation': _meterLocation,
        'additionalMeter': _meterNumber,
        'interiorPlumbing': _interiorPlumbing,
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );

        _email = '';
        _applicantFirstName = '';
        _applicantSecondName = '';
        _spouseName = '';
        _presentAddress = '';
        _previousAddress = '';
        _meterLocation = '';
        _meterNumber = '';
        _interiorPlumbing = false;
        _applicationType = 'Residential';
        _houseMaterial = 'Concrete';
        _ownershipStatus = 'Owned';
        _currentStep = 0;
        notifyListeners();
      } else {
        final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'Submission failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting application: $e')),
      );
    }

    _isSubmitting = false;
    notifyListeners();
  }
}
