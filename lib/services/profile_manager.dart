import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileManager {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  UserProfile? _currentProfile;
  static const String _profileKey = 'user_profile';

  UserProfile? get currentProfile => _currentProfile;

  // Initialize profile with phone number from OTP verification
  void initializeProfile(String phoneNumber) {
    _currentProfile = UserProfile(phoneNumber: phoneNumber);
    _saveProfile();
  }

  // Update profile data
  void updateProfile(UserProfile updatedProfile) {
    _currentProfile = updatedProfile;
    _saveProfile();
  }

  // Update specific fields
  void updateName(String name) {
    _currentProfile = _currentProfile?.copyWith(name: name);
    _saveProfile();
  }

  void updateDateOfBirth(DateTime dateOfBirth) {
    _currentProfile = _currentProfile?.copyWith(dateOfBirth: dateOfBirth);
    _saveProfile();
  }

  void updateGender(String gender) {
    _currentProfile = _currentProfile?.copyWith(gender: gender);
    _saveProfile();
  }

  void updateProfilePicture(String profilePicturePath) {
    _currentProfile =
        _currentProfile?.copyWith(profilePicturePath: profilePicturePath);
    _saveProfile();
  }

  void updateLocation({
    required String city,
    double? latitude,
    double? longitude,
    bool locationPermissionGranted = false,
  }) {
    _currentProfile = _currentProfile?.copyWith(
      city: city,
      latitude: latitude,
      longitude: longitude,
      locationPermissionGranted: locationPermissionGranted,
    );
    _saveProfile();
  }

  void updateMood(String mood) {
    _currentProfile = _currentProfile?.copyWith(mood: mood);
    _saveProfile();
  }

  // Save profile to local storage
  Future<void> _saveProfile() async {
    if (_currentProfile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(_currentProfile!.toJson()));
    }
  }

  // Load profile from local storage
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null) {
      final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
      _currentProfile = UserProfile.fromJson(profileMap);
    }
  }

  // Save profile to backend
  Future<bool> saveToBackend() async {
    if (_currentProfile == null || !_currentProfile!.isComplete) {
      return false;
    }

    try {
      // TODO: Implement actual backend API call
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful save
      print('Profile saved to backend: ${_currentProfile!.toJson()}');
      return true;
    } catch (e) {
      print('Error saving profile to backend: $e');
      return false;
    }
  }

  // Clear profile data
  Future<void> clearProfile() async {
    _currentProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  // Check if profile is complete
  bool get isProfileComplete => _currentProfile?.isComplete ?? false;

  // Get profile completion percentage
  double get completionPercentage {
    if (_currentProfile == null) return 0.0;

    int completedFields = 0;
    int totalFields = 5; // phoneNumber, name, dateOfBirth, gender, city

    if (_currentProfile!.phoneNumber != null) completedFields++;
    if (_currentProfile!.name != null) completedFields++;
    if (_currentProfile!.dateOfBirth != null) completedFields++;
    if (_currentProfile!.gender != null) completedFields++;
    if (_currentProfile!.city != null) completedFields++;

    return completedFields / totalFields;
  }
}
