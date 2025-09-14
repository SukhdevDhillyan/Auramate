import 'dart:async';
import 'dart:math';
import '../authentication/auth_service.dart';

class MockAuthService implements AuthService {
  static const String _mockVerificationId = 'mock-verification-id-12345';
  static const String _mockOTP = '123456'; // Fixed OTP for testing

  @override
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    String? countryCode,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate a mock verification ID
    final verificationId = 'mock-${DateTime.now().millisecondsSinceEpoch}';

    return AuthResult(
      success: true,
      verificationId: verificationId,
      errorMessage: null,
    );
  }

  @override
  Future<AuthResult> verifyPhoneOTP({
    required String verificationId,
    required String otp,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if OTP matches our mock OTP
    if (otp == _mockOTP) {
      return AuthResult(
        success: true,
        userId: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
        errorMessage: null,
      );
    } else {
      return AuthResult(
        success: false,
        errorMessage: 'Invalid verification code. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock email validation
    if (email.contains('@') && password.length >= 6) {
      return AuthResult(
        success: true,
        userId: 'mock-email-user-${DateTime.now().millisecondsSinceEpoch}',
        errorMessage: null,
      );
    } else {
      return AuthResult(
        success: false,
        errorMessage: 'Invalid email or password',
      );
    }
  }

  @override
  Future<AuthResult> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 1));

    return AuthResult(
      success: true,
      userId: 'mock-apple-user-${DateTime.now().millisecondsSinceEpoch}',
      errorMessage: null,
    );
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));

    return AuthResult(
      success: true,
      userId: 'mock-google-user-${DateTime.now().millisecondsSinceEpoch}',
      errorMessage: null,
    );
  }

  @override
  Future<AuthResult> signInWithFacebook() async {
    await Future.delayed(const Duration(seconds: 1));

    return AuthResult(
      success: true,
      userId: 'mock-facebook-user-${DateTime.now().millisecondsSinceEpoch}',
      errorMessage: null,
    );
  }

  @override
  Future<AuthResult> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return AuthResult(
      success: true,
      errorMessage: null,
    );
  }

  @override
  Future<bool> isUserSignedIn() async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Mock: return false for now
    return false;
  }

  @override
  Future<String?> getCurrentUserId() async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Mock: return null for now
    return null;
  }

  // Helper method to get the mock OTP for testing
  static String getMockOTP() {
    return _mockOTP;
  }
}

