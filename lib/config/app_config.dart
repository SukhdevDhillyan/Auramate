// Global App Configuration File
// All configurable values in one place for easy management

import '../authentication/auth_service.dart';

class AppConfig {
  // ========================================
  // AUTHENTICATION CONFIGURATION
  // ========================================

  // 🔥 AUTH SERVICE SELECTION
  // Change this to switch between different authentication services
  static const AuthServiceType AUTH_SERVICE =
      AuthServiceType.mock; // Use mock for development without billing
  // Options: AuthServiceType.firebase, AuthServiceType.twilio, AuthServiceType.awsCognito, AuthServiceType.custom, AuthServiceType.mock

  // 📱 AUTH METHOD PREFERENCE
  static const AuthMethod DEFAULT_AUTH_METHOD = AuthMethod.phone;
  // Options: AuthMethod.phone, AuthMethod.email, AuthMethod.apple, AuthMethod.google, AuthMethod.facebook

  // ⏱️ TIMEOUT SETTINGS
  static const Duration PHONE_AUTH_TIMEOUT = Duration(seconds: 60);
  static const Duration RESEND_COOLDOWN = Duration(seconds: 30);
  static const Duration SESSION_TIMEOUT = Duration(days: 30);
  static const Duration API_TIMEOUT = Duration(seconds: 30);

  // 🔢 OTP SETTINGS
  static const int OTP_LENGTH = 6;
  static const int MAX_RESEND_ATTEMPTS = 3;

  // 🔐 SECURITY SETTINGS
  static const bool ENABLE_BIOMETRIC_AUTH = false;
  static const bool ENABLE_REMEMBER_ME = true;
  static const bool AUTO_REFRESH_TOKEN = true;

  // 🎨 UI SETTINGS
  static const bool SHOW_LOADING_INDICATORS = true;
  static const bool ENABLE_ERROR_MESSAGES = true;
  static const bool ENABLE_DEBUG_MODE = true; // Set to false for production

  // ========================================
  // APP GENERAL SETTINGS
  // ========================================

  // 📱 APP INFORMATION
  static const String APP_NAME = 'Auramate';
  static const String APP_VERSION = '1.0.0';
  static const String APP_DESCRIPTION = 'Your vibe. Your people.';

  // 🌐 API SETTINGS
  static const String API_BASE_URL = 'https://api.auramate.com';
  static const String API_VERSION = 'v1';
  static const int API_RETRY_ATTEMPTS = 3;

  // 📊 ANALYTICS SETTINGS
  static const bool ENABLE_ANALYTICS = true;
  static const bool ENABLE_CRASH_REPORTING = true;
  static const bool ENABLE_PERFORMANCE_MONITORING = true;

  // 🔔 NOTIFICATION SETTINGS
  static const bool ENABLE_PUSH_NOTIFICATIONS = true;
  static const bool ENABLE_EMAIL_NOTIFICATIONS = false;
  static const bool ENABLE_SMS_NOTIFICATIONS = false;

  // 💾 STORAGE SETTINGS
  static const bool ENABLE_LOCAL_CACHING = true;
  static const Duration CACHE_DURATION = Duration(hours: 24);
  static const int MAX_CACHE_SIZE = 100; // MB

  // ========================================
  // FEATURE FLAGS
  // ========================================

  // 🎯 FEATURE TOGGLES
  static const bool ENABLE_SOCIAL_LOGIN = true;
  static const bool ENABLE_EMAIL_LOGIN = true;
  static const bool ENABLE_PHONE_LOGIN = true;
  static const bool ENABLE_APPLE_SIGN_IN = false;
  static const bool ENABLE_GOOGLE_SIGN_IN = false;
  static const bool ENABLE_FACEBOOK_SIGN_IN = false;

  // 🎮 GAMIFICATION FEATURES
  static const bool ENABLE_SCORE_SYSTEM = true;
  static const bool ENABLE_ACHIEVEMENTS = true;
  static const bool ENABLE_LEADERBOARDS = false;

  // 💬 SOCIAL FEATURES
  static const bool ENABLE_CHAT = true;
  static const bool ENABLE_GROUPS = true;
  static const bool ENABLE_POSTS = true;
  static const bool ENABLE_COMMENTS = true;
  static const bool ENABLE_LIKES = true;

  // ========================================
  // ENVIRONMENT SETTINGS
  // ========================================

  // 🌍 ENVIRONMENT SELECTION
  static const Environment ENVIRONMENT = Environment.development;
  // Options: Environment.development, Environment.staging, Environment.production

  // 🔧 DEBUG SETTINGS
  static const bool SHOW_DEBUG_INFO = true;
  static const bool ENABLE_LOGGING = true;
  static const bool ENABLE_NETWORK_LOGGING = true;

  // ========================================
  // THIRD-PARTY SERVICE SETTINGS
  // ========================================

  // 🔥 FIREBASE SETTINGS
  static const bool ENABLE_FIREBASE_ANALYTICS = true;
  static const bool ENABLE_FIREBASE_CRASHLYTICS = true;
  static const bool ENABLE_FIREBASE_PERFORMANCE = true;

  // 📊 MIXPANEL SETTINGS (if using)
  static const bool ENABLE_MIXPANEL = false;
  static const String MIXPANEL_TOKEN = 'YOUR_MIXPANEL_TOKEN';

  // 📈 AMPLITUDE SETTINGS (if using)
  static const bool ENABLE_AMPLITUDE = false;
  static const String AMPLITUDE_API_KEY = 'YOUR_AMPLITUDE_API_KEY';

  // ========================================
  // LOCALIZATION SETTINGS
  // ========================================

  // 🌐 LANGUAGE SETTINGS
  static const String DEFAULT_LANGUAGE = 'en';
  static const List<String> SUPPORTED_LANGUAGES = [
    'en',
    'es',
    'fr',
    'de',
    'hi'
  ];
  static const bool ENABLE_AUTO_LANGUAGE_DETECTION = true;

  // 📍 REGION SETTINGS
  static const String DEFAULT_REGION = 'US';
  static const String DEFAULT_TIMEZONE = 'UTC';

  // ========================================
  // THEME SETTINGS
  // ========================================

  // 🎨 THEME CONFIGURATION
  static const bool ENABLE_DARK_MODE = true;
  static const bool ENABLE_DYNAMIC_COLORS = true;
  static const String DEFAULT_THEME = 'light';

  // ========================================
  // PERFORMANCE SETTINGS
  // ========================================

  // ⚡ PERFORMANCE OPTIMIZATIONS
  static const bool ENABLE_IMAGE_CACHING = true;
  static const bool ENABLE_LAZY_LOADING = true;
  static const bool ENABLE_PRELOADING = true;
  static const int MAX_CONCURRENT_REQUESTS = 5;

  // ========================================
  // SECURITY SETTINGS
  // ========================================

  // 🔒 SECURITY CONFIGURATION
  static const bool ENABLE_SSL_PINNING = false;
  static const bool ENABLE_APP_SIGNING = true;
  static const bool ENABLE_PROGUARD = true;
  static const bool ENABLE_OBFUSCATION = true;

  // ========================================
  // TESTING SETTINGS
  // ========================================

  // 🧪 TESTING CONFIGURATION
  static const bool ENABLE_MOCK_DATA = false;
  static const bool ENABLE_TEST_MODE = false;
  static const String TEST_USER_EMAIL = 'test@auramate.com';
  static const String TEST_USER_PHONE = '+1234567890';

  // ========================================
  // MONETIZATION SETTINGS
  // ========================================

  // 💰 MONETIZATION FEATURES
  static const bool ENABLE_IN_APP_PURCHASES = false;
  static const bool ENABLE_SUBSCRIPTIONS = false;
  static const bool ENABLE_ADS = false;
  static const bool ENABLE_PREMIUM_FEATURES = false;

  // ========================================
  // HELPER METHODS
  // ========================================

  // Check if running in development mode
  static bool get isDevelopment => ENVIRONMENT == Environment.development;

  // Check if running in production mode
  static bool get isProduction => ENVIRONMENT == Environment.production;

  // Check if running in staging mode
  static bool get isStaging => ENVIRONMENT == Environment.staging;

  // Get API URL based on environment
  static String get apiUrl {
    switch (ENVIRONMENT) {
      case Environment.development:
        return 'https://dev-api.auramate.com';
      case Environment.staging:
        return 'https://staging-api.auramate.com';
      case Environment.production:
        return 'https://api.auramate.com';
    }
  }

  // Get WebSocket URL based on environment
  static String get websocketUrl {
    switch (ENVIRONMENT) {
      case Environment.development:
        return 'wss://dev-ws.auramate.com';
      case Environment.staging:
        return 'wss://staging-ws.auramate.com';
      case Environment.production:
        return 'wss://ws.auramate.com';
    }
  }

  // Check if feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'social_login':
        return ENABLE_SOCIAL_LOGIN;
      case 'email_login':
        return ENABLE_EMAIL_LOGIN;
      case 'phone_login':
        return ENABLE_PHONE_LOGIN;
      case 'apple_sign_in':
        return ENABLE_APPLE_SIGN_IN;
      case 'google_sign_in':
        return ENABLE_GOOGLE_SIGN_IN;
      case 'facebook_sign_in':
        return ENABLE_FACEBOOK_SIGN_IN;
      case 'chat':
        return ENABLE_CHAT;
      case 'groups':
        return ENABLE_GROUPS;
      case 'posts':
        return ENABLE_POSTS;
      case 'comments':
        return ENABLE_COMMENTS;
      case 'likes':
        return ENABLE_LIKES;
      case 'score_system':
        return ENABLE_SCORE_SYSTEM;
      case 'achievements':
        return ENABLE_ACHIEVEMENTS;
      case 'leaderboards':
        return ENABLE_LEADERBOARDS;
      default:
        return false;
    }
  }
}

// ========================================
// ENUMS
// ========================================

enum Environment {
  development,
  staging,
  production,
}

// ========================================
// CONFIGURATION PRESETS
// ========================================

class ConfigPresets {
  // Development configuration
  static const Map<String, dynamic> development = {
    'AUTH_SERVICE': AuthServiceType.firebase,
    'ENVIRONMENT': Environment.development,
    'ENABLE_DEBUG_MODE': true,
    'ENABLE_LOGGING': true,
    'ENABLE_MOCK_DATA': true,
    'API_BASE_URL': 'https://dev-api.auramate.com',
  };

  // Staging configuration
  static const Map<String, dynamic> staging = {
    'AUTH_SERVICE': AuthServiceType.firebase,
    'ENVIRONMENT': Environment.staging,
    'ENABLE_DEBUG_MODE': false,
    'ENABLE_LOGGING': true,
    'ENABLE_MOCK_DATA': false,
    'API_BASE_URL': 'https://staging-api.auramate.com',
  };

  // Production configuration
  static const Map<String, dynamic> production = {
    'AUTH_SERVICE': AuthServiceType.firebase,
    'ENVIRONMENT': Environment.production,
    'ENABLE_DEBUG_MODE': false,
    'ENABLE_LOGGING': false,
    'ENABLE_MOCK_DATA': false,
    'API_BASE_URL': 'https://api.auramate.com',
  };
}
