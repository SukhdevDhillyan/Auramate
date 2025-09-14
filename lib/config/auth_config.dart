// Authentication Configuration File
// Centralized configuration for all authentication services
import '../authentication/auth_service.dart';
import 'app_config.dart';

class AuthConfig {
  // ========================================
  // FIREBASE CONFIGURATION
  // ========================================
  static const FirebaseConfig firebase = FirebaseConfig(
    // Web Configuration (You'll need to add web app in Firebase Console)
    webApiKey:
        'AIzaSyCfZp7Vq08tW-VpG3Jox82TSVxMk8rLuwU', // Using iOS API key for now
    webAppId:
        '1:408501602779:web:YOUR_WEB_APP_ID', // Add web app in Firebase Console
    webMessagingSenderId: '408501602779',
    webProjectId: 'auramate-app',
    webAuthDomain: 'auramate-app.firebaseapp.com',
    webStorageBucket: 'auramate-app.firebasestorage.app',

    // Android Configuration (from google-services.json)
    androidApiKey: 'AIzaSyANuzmU1Mui8JDIZJSWWQRSkgTHY_N1ycc',
    androidAppId: '1:408501602779:android:e1bfb9fc71ed7dee877ffe',
    androidMessagingSenderId: '408501602779',
    androidProjectId: 'auramate-app',
    androidStorageBucket: 'auramate-app.firebasestorage.app',

    // iOS Configuration (from GoogleService-Info.plist)
    iosApiKey: 'AIzaSyCfZp7Vq08tW-VpG3Jox82TSVxMk8rLuwU',
    iosAppId: '1:408501602779:ios:567e7e8733df7c1e877ffe',
    iosMessagingSenderId: '408501602779',
    iosProjectId: 'auramate-app',
    iosStorageBucket: 'auramate-app.firebasestorage.app',
    iosClientId:
        '408501602779-YOUR_IOS_CLIENT_ID.apps.googleusercontent.com', // Add in Firebase Console
    iosBundleId: 'com.example.auramate',

    // macOS Configuration (using iOS config for now)
    macosApiKey: 'AIzaSyCfZp7Vq08tW-VpG3Jox82TSVxMk8rLuwU',
    macosAppId:
        '1:408501602779:macos:YOUR_MACOS_APP_ID', // Add macOS app in Firebase Console
    macosMessagingSenderId: '408501602779',
    macosProjectId: 'auramate-app',
    macosStorageBucket: 'auramate-app.firebasestorage.app',
    macosClientId:
        '408501602779-YOUR_MACOS_CLIENT_ID.apps.googleusercontent.com', // Add in Firebase Console
    macosBundleId: 'com.example.auramate',

    // Windows Configuration (using Android config for now)
    windowsApiKey: 'AIzaSyANuzmU1Mui8JDIZJSWWQRSkgTHY_N1ycc',
    windowsAppId:
        '1:408501602779:windows:YOUR_WINDOWS_APP_ID', // Add Windows app in Firebase Console
    windowsMessagingSenderId: '408501602779',
    windowsProjectId: 'auramate-app',
    windowsStorageBucket: 'auramate-app.firebasestorage.app',
  );

  // ========================================
  // TWILIO CONFIGURATION
  // ========================================
  static const TwilioConfig twilio = TwilioConfig(
    accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
    authToken: 'YOUR_TWILIO_AUTH_TOKEN',
    twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
    serviceId: 'YOUR_TWILIO_VERIFY_SERVICE_ID', // For Verify API
  );

  // ========================================
  // AWS COGNITO CONFIGURATION
  // ========================================
  static const AWSCognitoConfig awsCognito = AWSCognitoConfig(
    userPoolId: 'YOUR_COGNITO_USER_POOL_ID',
    clientId: 'YOUR_COGNITO_CLIENT_ID',
    region: 'YOUR_AWS_REGION', // e.g., 'us-east-1'
    identityPoolId: 'YOUR_COGNITO_IDENTITY_POOL_ID',
  );

  // ========================================
  // CUSTOM BACKEND CONFIGURATION
  // ========================================
  static const CustomBackendConfig customBackend = CustomBackendConfig(
    baseUrl: 'https://your-backend-api.com',
    apiKey: 'YOUR_BACKEND_API_KEY',
    timeout: Duration(seconds: 30),
    retryAttempts: 3,
  );

  // ========================================
  // GOOGLE SIGN-IN CONFIGURATION
  // ========================================
  static const GoogleSignInConfig googleSignIn = GoogleSignInConfig(
    webClientId: 'YOUR_GOOGLE_WEB_CLIENT_ID',
    iosClientId: 'YOUR_GOOGLE_IOS_CLIENT_ID',
    androidClientId: 'YOUR_GOOGLE_ANDROID_CLIENT_ID',
  );

  // ========================================
  // APPLE SIGN-IN CONFIGURATION
  // ========================================
  static const AppleSignInConfig appleSignIn = AppleSignInConfig(
    serviceId: 'com.example.auramate.signin',
    teamId: 'YOUR_APPLE_TEAM_ID',
    keyId: 'YOUR_APPLE_KEY_ID',
    privateKey: 'YOUR_APPLE_PRIVATE_KEY',
  );

  // ========================================
  // FACEBOOK SIGN-IN CONFIGURATION
  // ========================================
  static const FacebookSignInConfig facebookSignIn = FacebookSignInConfig(
    appId: 'YOUR_FACEBOOK_APP_ID',
    clientToken: 'YOUR_FACEBOOK_CLIENT_TOKEN',
    displayName: 'Auramate',
  );

  // ========================================
  // GENERAL AUTH SETTINGS
  // ========================================
  static const AuthSettings general = AuthSettings(
    // Default authentication method
    defaultAuthMethod: AppConfig.DEFAULT_AUTH_METHOD,

    // Default authentication service
    defaultAuthService: AppConfig.AUTH_SERVICE,

    // Phone authentication settings
    phoneAuthTimeout: AppConfig.PHONE_AUTH_TIMEOUT,
    otpLength: AppConfig.OTP_LENGTH,
    resendCooldown: AppConfig.RESEND_COOLDOWN,

    // Session settings
    sessionTimeout: AppConfig.SESSION_TIMEOUT,
    autoRefreshToken: AppConfig.AUTO_REFRESH_TOKEN,

    // Security settings
    enableBiometricAuth: AppConfig.ENABLE_BIOMETRIC_AUTH,
    enableRememberMe: AppConfig.ENABLE_REMEMBER_ME,

    // UI settings
    showLoadingIndicators: AppConfig.SHOW_LOADING_INDICATORS,
    enableErrorMessages: AppConfig.ENABLE_ERROR_MESSAGES,
  );
}

// ========================================
// CONFIGURATION CLASSES
// ========================================

class FirebaseConfig {
  final String webApiKey;
  final String webAppId;
  final String webMessagingSenderId;
  final String webProjectId;
  final String webAuthDomain;
  final String webStorageBucket;

  final String androidApiKey;
  final String androidAppId;
  final String androidMessagingSenderId;
  final String androidProjectId;
  final String androidStorageBucket;

  final String iosApiKey;
  final String iosAppId;
  final String iosMessagingSenderId;
  final String iosProjectId;
  final String iosStorageBucket;
  final String iosClientId;
  final String iosBundleId;

  final String macosApiKey;
  final String macosAppId;
  final String macosMessagingSenderId;
  final String macosProjectId;
  final String macosStorageBucket;
  final String macosClientId;
  final String macosBundleId;

  final String windowsApiKey;
  final String windowsAppId;
  final String windowsMessagingSenderId;
  final String windowsProjectId;
  final String windowsStorageBucket;

  const FirebaseConfig({
    required this.webApiKey,
    required this.webAppId,
    required this.webMessagingSenderId,
    required this.webProjectId,
    required this.webAuthDomain,
    required this.webStorageBucket,
    required this.androidApiKey,
    required this.androidAppId,
    required this.androidMessagingSenderId,
    required this.androidProjectId,
    required this.androidStorageBucket,
    required this.iosApiKey,
    required this.iosAppId,
    required this.iosMessagingSenderId,
    required this.iosProjectId,
    required this.iosStorageBucket,
    required this.iosClientId,
    required this.iosBundleId,
    required this.macosApiKey,
    required this.macosAppId,
    required this.macosMessagingSenderId,
    required this.macosProjectId,
    required this.macosStorageBucket,
    required this.macosClientId,
    required this.macosBundleId,
    required this.windowsApiKey,
    required this.windowsAppId,
    required this.windowsMessagingSenderId,
    required this.windowsProjectId,
    required this.windowsStorageBucket,
  });
}

class TwilioConfig {
  final String accountSid;
  final String authToken;
  final String twilioNumber;
  final String serviceId;

  const TwilioConfig({
    required this.accountSid,
    required this.authToken,
    required this.twilioNumber,
    required this.serviceId,
  });
}

class AWSCognitoConfig {
  final String userPoolId;
  final String clientId;
  final String region;
  final String identityPoolId;

  const AWSCognitoConfig({
    required this.userPoolId,
    required this.clientId,
    required this.region,
    required this.identityPoolId,
  });
}

class CustomBackendConfig {
  final String baseUrl;
  final String apiKey;
  final Duration timeout;
  final int retryAttempts;

  const CustomBackendConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.timeout,
    required this.retryAttempts,
  });
}

class GoogleSignInConfig {
  final String webClientId;
  final String iosClientId;
  final String androidClientId;

  const GoogleSignInConfig({
    required this.webClientId,
    required this.iosClientId,
    required this.androidClientId,
  });
}

class AppleSignInConfig {
  final String serviceId;
  final String teamId;
  final String keyId;
  final String privateKey;

  const AppleSignInConfig({
    required this.serviceId,
    required this.teamId,
    required this.keyId,
    required this.privateKey,
  });
}

class FacebookSignInConfig {
  final String appId;
  final String clientToken;
  final String displayName;

  const FacebookSignInConfig({
    required this.appId,
    required this.clientToken,
    required this.displayName,
  });
}

class AuthSettings {
  final AuthMethod defaultAuthMethod;
  final AuthServiceType defaultAuthService;
  final Duration phoneAuthTimeout;
  final int otpLength;
  final Duration resendCooldown;
  final Duration sessionTimeout;
  final bool autoRefreshToken;
  final bool enableBiometricAuth;
  final bool enableRememberMe;
  final bool showLoadingIndicators;
  final bool enableErrorMessages;

  const AuthSettings({
    required this.defaultAuthMethod,
    required this.defaultAuthService,
    required this.phoneAuthTimeout,
    required this.otpLength,
    required this.resendCooldown,
    required this.sessionTimeout,
    required this.autoRefreshToken,
    required this.enableBiometricAuth,
    required this.enableRememberMe,
    required this.showLoadingIndicators,
    required this.enableErrorMessages,
  });
}

// ========================================
// ENUMS (imported from auth_service.dart)
// ========================================

// These enums are imported from auth_service.dart to avoid duplication
// AuthMethod and AuthServiceType are defined in lib/authentication/auth_service.dart
