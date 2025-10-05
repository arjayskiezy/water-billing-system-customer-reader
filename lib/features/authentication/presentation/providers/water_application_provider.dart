import 'package:flutter/material.dart';

class WaterApplicationProvider extends ChangeNotifier {
  // -------------------- Form fields --------------------
  String email = '';
  String applicantName = '';
  String spouseName = '';
  String presentAddress = '';
  String previousAddress = '';
  String faucetLocation = '';
  String additionalFaucet = '';

  String applicationType = 'Residential';
  String houseMaterial = 'Wood';
  String ownershipStatus = 'Owned';
  bool interiorPlumbing = false;

  int currentStep = 0;

  // -------------------- Setters with notify --------------------
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setApplicantName(String value) {
    applicantName = value;
    notifyListeners();
  }

  void setSpouseName(String value) {
    spouseName = value;
    notifyListeners();
  }

  void setPresentAddress(String value) {
    presentAddress = value;
    notifyListeners();
  }

  void setPreviousAddress(String value) {
    previousAddress = value;
    notifyListeners();
  }

  void setFaucetLocation(String value) {
    faucetLocation = value;
    notifyListeners();
  }

  void setAdditionalFaucet(String value) {
    additionalFaucet = value;
    notifyListeners();
  }

  void setApplicationType(String value) {
    applicationType = value;
    notifyListeners();
  }

  void setHouseMaterial(String value) {
    houseMaterial = value;
    notifyListeners();
  }

  void setOwnershipStatus(String value) {
    ownershipStatus = value;
    notifyListeners();
  }

  void setInteriorPlumbing(bool value) {
    interiorPlumbing = value;
    notifyListeners();
  }

  void nextStep() {
    currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep > 0) currentStep--;
    notifyListeners();
  }

  // -------------------- Submit --------------------
  void submitForm() {
    // TODO: send data to backend
    debugPrint('Form Submitted');
    debugPrint('Email: $email');
    debugPrint('Applicant: $applicantName');
    debugPrint('Spouse: $spouseName');
    debugPrint('Present Address: $presentAddress');
    debugPrint('Previous Address: $previousAddress');
    debugPrint('Faucet Location: $faucetLocation');
    debugPrint('Additional Faucet: $additionalFaucet');
    debugPrint('Application Type: $applicationType');
    debugPrint('House Material: $houseMaterial');
    debugPrint('Ownership Status: $ownershipStatus');
    debugPrint('Interior Plumbing: $interiorPlumbing');
  }
}
