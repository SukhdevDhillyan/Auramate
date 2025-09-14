import 'package:flutter/material.dart';
import 'firebase_auth_service.dart';
import 'twilio_auth_service.dart';
import 'aws_cognito_auth_service.dart';
import 'custom_auth_service.dart';
import 'mock_auth_service.dart';

// Authentication methods enum
enum AuthMethod {
  phone,
  email,
  apple,
  google,
  facebook,
}

// Authentication service types enum
enum AuthServiceType {
  firebase,
  twilio,
  awsCognito,
  custom,
  mock, // For development/testing without billing
}

// Authentication result class
class AuthResult {
  final bool success;
  final String? userId;
  final String? errorMessage;
  final String? verificationId; // For phone auth
  final int? resendToken; // For phone auth

  AuthResult({
    required this.success,
    this.userId,
    this.errorMessage,
    this.verificationId,
    this.resendToken,
  });
}

// Authentication service interface
abstract class AuthService {
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required String countryCode,
  });

  Future<AuthResult> verifyPhoneOTP({
    required String verificationId,
    required String otp,
  });

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthResult> signInWithApple();
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithFacebook();

  Future<void> signOut();
  Future<bool> isUserSignedIn();
  Future<String?> getCurrentUserId();
}

// Authentication Manager - Main class to handle multiple services
class AuthenticationManager {
  static final AuthenticationManager _instance =
      AuthenticationManager._internal();
  factory AuthenticationManager() => _instance;
  AuthenticationManager._internal();

  AuthServiceType _currentService = AuthServiceType.firebase;
  late AuthService _authService;

  // Initialize with default service
  void initialize({AuthServiceType serviceType = AuthServiceType.firebase}) {
    _currentService = serviceType;
    _authService = _getAuthService(serviceType);
  }

  // Switch authentication service dynamically
  void switchService(AuthServiceType serviceType) {
    _currentService = serviceType;
    _authService = _getAuthService(serviceType);
  }

  // Get current authentication service
  AuthService get currentService => _authService;

  // Get current service type
  AuthServiceType get currentServiceType => _currentService;

  // Factory method to get appropriate auth service
  AuthService _getAuthService(AuthServiceType serviceType) {
    switch (serviceType) {
      case AuthServiceType.firebase:
        return FirebaseAuthService();
      case AuthServiceType.twilio:
        return TwilioAuthService();
      case AuthServiceType.awsCognito:
        return AWSCognitoAuthService();
      case AuthServiceType.custom:
        return CustomAuthService();
      case AuthServiceType.mock:
        return MockAuthService();
    }
  }

  // Convenience methods that delegate to current service
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    return await _authService.signInWithPhone(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
    );
  }

  Future<AuthResult> verifyPhoneOTP({
    required String verificationId,
    required String otp,
  }) async {
    return await _authService.verifyPhoneOTP(
      verificationId: verificationId,
      otp: otp,
    );
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmail(
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signInWithApple() async {
    return await _authService.signInWithApple();
  }

  Future<AuthResult> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<AuthResult> signInWithFacebook() async {
    return await _authService.signInWithFacebook();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> isUserSignedIn() async {
    return await _authService.isUserSignedIn();
  }

  Future<String?> getCurrentUserId() async {
    return await _authService.getCurrentUserId();
  }
}
