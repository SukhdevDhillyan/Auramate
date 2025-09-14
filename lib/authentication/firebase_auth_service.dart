import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import '../config/auth_config.dart';

// Firebase Authentication Service Implementation
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  @override
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final completer = Completer<AuthResult>();

      await _auth.verifyPhoneNumber(
        phoneNumber: '$countryCode$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            completer.complete(AuthResult(
              success: true,
              userId: _auth.currentUser?.uid,
            ));
          } catch (e) {
            completer.complete(AuthResult(
              success: false,
              errorMessage: e.toString(),
            ));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(AuthResult(
            success: false,
            errorMessage: e.message ?? 'Verification failed',
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          completer.complete(AuthResult(
            success: true,
            verificationId: verificationId,
            resendToken: resendToken,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: AuthConfig.general.phoneAuthTimeout,
      );

      return await completer.future;
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> verifyPhoneOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // Create credential with verification ID and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in with credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return AuthResult(
        success: true,
        userId: userCredential.user?.uid,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Invalid OTP code. Please try again.';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Invalid verification ID. Please request a new code.';
          break;
        case 'session-expired':
          errorMessage = 'Session expired. Please request a new code.';
          break;
        default:
          errorMessage = e.message ?? 'Verification failed';
      }

      return AuthResult(
        success: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthResult(
        success: true,
        userId: userCredential.user?.uid,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = e.message ?? 'Sign in failed';
      }

      return AuthResult(
        success: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithApple() async {
    try {
      // TODO: Implement Apple Sign-In with Firebase
      // import 'package:sign_in_with_apple/sign_in_with_apple.dart';
      // final credential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: credential.identityToken,
      //   accessToken: credential.authorizationCode,
      // );
      // UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      await Future.delayed(const Duration(seconds: 1));

      return AuthResult(
        success: true,
        userId: 'apple_user_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      // TODO: Implement Google Sign-In with Firebase
      // import 'package:google_sign_in/google_sign_in.dart';
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
      // UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      await Future.delayed(const Duration(seconds: 1));

      return AuthResult(
        success: true,
        userId: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithFacebook() async {
    try {
      // TODO: Implement Facebook Sign-In with Firebase
      // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
      // final LoginResult result = await FacebookAuth.instance.login();
      // final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      // UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      await Future.delayed(const Duration(seconds: 1));

      return AuthResult(
        success: true,
        userId: 'facebook_user_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<bool> isUserSignedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }
}
