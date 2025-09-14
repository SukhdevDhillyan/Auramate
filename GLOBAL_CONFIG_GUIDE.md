# Global Configuration Guide

## 🎯 **One File to Rule Them All**

I've created a centralized global configuration system in `lib/config/app_config.dart` that puts ALL configurable values in one place. Now you can change any setting without digging through multiple files!

## 📁 **File Structure**

```
lib/
├── config/
│   ├── app_config.dart          # 🌟 GLOBAL CONFIG (MAIN FILE)
│   └── auth_config.dart         # Auth-specific config (uses global)
├── authentication/
│   └── ... (auth services)
└── main.dart                    # Uses global config
```

## 🔥 **Quick Configuration Changes**

### **Switch Authentication Service**
```dart
// In lib/config/app_config.dart
static const AuthServiceType AUTH_SERVICE = AuthServiceType.firebase;
// Change to: AuthServiceType.twilio, AuthServiceType.awsCognito, AuthServiceType.custom
```

### **Change Environment**
```dart
// In lib/config/app_config.dart
static const Environment ENVIRONMENT = Environment.development;
// Change to: Environment.staging, Environment.production
```

### **Toggle Features**
```dart
// In lib/config/app_config.dart
static const bool ENABLE_SOCIAL_LOGIN = true;
static const bool ENABLE_CHAT = true;
static const bool ENABLE_SCORE_SYSTEM = true;
// Set to false to disable features
```

## 🎮 **Feature Flags**

### **Authentication Features**
```dart
static const bool ENABLE_SOCIAL_LOGIN = true;
static const bool ENABLE_EMAIL_LOGIN = true;
static const bool ENABLE_PHONE_LOGIN = true;
static const bool ENABLE_APPLE_SIGN_IN = false;
static const bool ENABLE_GOOGLE_SIGN_IN = false;
static const bool ENABLE_FACEBOOK_SIGN_IN = false;
```

### **Social Features**
```dart
static const bool ENABLE_CHAT = true;
static const bool ENABLE_GROUPS = true;
static const bool ENABLE_POSTS = true;
static const bool ENABLE_COMMENTS = true;
static const bool ENABLE_LIKES = true;
```

### **Gamification Features**
```dart
static const bool ENABLE_SCORE_SYSTEM = true;
static const bool ENABLE_ACHIEVEMENTS = true;
static const bool ENABLE_LEADERBOARDS = false;
```

## ⏱️ **Timeout & Performance Settings**

### **Authentication Timeouts**
```dart
static const Duration PHONE_AUTH_TIMEOUT = Duration(seconds: 60);
static const Duration RESEND_COOLDOWN = Duration(seconds: 30);
static const Duration SESSION_TIMEOUT = Duration(days: 30);
static const Duration API_TIMEOUT = Duration(seconds: 30);
```

### **OTP Settings**
```dart
static const int OTP_LENGTH = 6;
static const int MAX_RESEND_ATTEMPTS = 3;
```

## 🌍 **Environment Management**

### **Environment Selection**
```dart
static const Environment ENVIRONMENT = Environment.development;
// Options: Environment.development, Environment.staging, Environment.production
```

### **Environment-Specific URLs**
The system automatically uses the correct URLs based on environment:
- **Development**: `https://dev-api.auramate.com`
- **Staging**: `https://staging-api.auramate.com`
- **Production**: `https://api.auramate.com`

## 🔧 **Debug & Development Settings**

### **Debug Mode**
```dart
static const bool ENABLE_DEBUG_MODE = true; // Set to false for production
static const bool SHOW_DEBUG_INFO = true;
static const bool ENABLE_LOGGING = true;
static const bool ENABLE_NETWORK_LOGGING = true;
```

### **Testing Settings**
```dart
static const bool ENABLE_MOCK_DATA = false;
static const bool ENABLE_TEST_MODE = false;
static const String TEST_USER_EMAIL = 'test@auramate.com';
static const String TEST_USER_PHONE = '+1234567890';
```

## 🎨 **UI & Theme Settings**

### **Theme Configuration**
```dart
static const bool ENABLE_DARK_MODE = true;
static const bool ENABLE_DYNAMIC_COLORS = true;
static const String DEFAULT_THEME = 'light';
```

### **UI Settings**
```dart
static const bool SHOW_LOADING_INDICATORS = true;
static const bool ENABLE_ERROR_MESSAGES = true;
```

## 📊 **Analytics & Monitoring**

### **Firebase Services**
```dart
static const bool ENABLE_FIREBASE_ANALYTICS = true;
static const bool ENABLE_FIREBASE_CRASHLYTICS = true;
static const bool ENABLE_FIREBASE_PERFORMANCE = true;
```

### **Third-Party Analytics**
```dart
static const bool ENABLE_MIXPANEL = false;
static const bool ENABLE_AMPLITUDE = false;
```

## 🔔 **Notification Settings**

```dart
static const bool ENABLE_PUSH_NOTIFICATIONS = true;
static const bool ENABLE_EMAIL_NOTIFICATIONS = false;
static const bool ENABLE_SMS_NOTIFICATIONS = false;
```

## 💾 **Storage & Caching**

```dart
static const bool ENABLE_LOCAL_CACHING = true;
static const Duration CACHE_DURATION = Duration(hours: 24);
static const int MAX_CACHE_SIZE = 100; // MB
```

## 🌐 **Localization Settings**

```dart
static const String DEFAULT_LANGUAGE = 'en';
static const List<String> SUPPORTED_LANGUAGES = ['en', 'es', 'fr', 'de', 'hi'];
static const bool ENABLE_AUTO_LANGUAGE_DETECTION = true;
static const String DEFAULT_REGION = 'US';
static const String DEFAULT_TIMEZONE = 'UTC';
```

## ⚡ **Performance Settings**

```dart
static const bool ENABLE_IMAGE_CACHING = true;
static const bool ENABLE_LAZY_LOADING = true;
static const bool ENABLE_PRELOADING = true;
static const int MAX_CONCURRENT_REQUESTS = 5;
```

## 🔒 **Security Settings**

```dart
static const bool ENABLE_SSL_PINNING = false;
static const bool ENABLE_APP_SIGNING = true;
static const bool ENABLE_PROGUARD = true;
static const bool ENABLE_OBFUSCATION = true;
```

## 💰 **Monetization Settings**

```dart
static const bool ENABLE_IN_APP_PURCHASES = false;
static const bool ENABLE_SUBSCRIPTIONS = false;
static const bool ENABLE_ADS = false;
static const bool ENABLE_PREMIUM_FEATURES = false;
```

## 🛠️ **Helper Methods**

### **Environment Checks**
```dart
AppConfig.isDevelopment  // Check if in development
AppConfig.isProduction   // Check if in production
AppConfig.isStaging      // Check if in staging
```

### **Dynamic URLs**
```dart
AppConfig.apiUrl         // Get API URL based on environment
AppConfig.websocketUrl   // Get WebSocket URL based on environment
```

### **Feature Checks**
```dart
AppConfig.isFeatureEnabled('social_login')  // Check if feature is enabled
AppConfig.isFeatureEnabled('chat')          // Check if chat is enabled
AppConfig.isFeatureEnabled('posts')         // Check if posts are enabled
```

## 🚀 **Common Configuration Changes**

### **Switch to Twilio Auth**
```dart
// In lib/config/app_config.dart
static const AuthServiceType AUTH_SERVICE = AuthServiceType.twilio;
```

### **Disable Social Features**
```dart
// In lib/config/app_config.dart
static const bool ENABLE_CHAT = false;
static const bool ENABLE_GROUPS = false;
static const bool ENABLE_POSTS = false;
```

### **Enable Production Mode**
```dart
// In lib/config/app_config.dart
static const Environment ENVIRONMENT = Environment.production;
static const bool ENABLE_DEBUG_MODE = false;
static const bool ENABLE_LOGGING = false;
```

### **Change OTP Settings**
```dart
// In lib/config/app_config.dart
static const int OTP_LENGTH = 4;  // Change from 6 to 4 digits
static const Duration PHONE_AUTH_TIMEOUT = Duration(seconds: 120);  // Increase timeout
```

## 📋 **Configuration Checklist**

### **Before Development**
- [ ] Set `ENVIRONMENT = Environment.development`
- [ ] Set `ENABLE_DEBUG_MODE = true`
- [ ] Set `ENABLE_LOGGING = true`
- [ ] Set `ENABLE_MOCK_DATA = true`

### **Before Staging**
- [ ] Set `ENVIRONMENT = Environment.staging`
- [ ] Set `ENABLE_DEBUG_MODE = false`
- [ ] Set `ENABLE_LOGGING = true`
- [ ] Set `ENABLE_MOCK_DATA = false`

### **Before Production**
- [ ] Set `ENVIRONMENT = Environment.production`
- [ ] Set `ENABLE_DEBUG_MODE = false`
- [ ] Set `ENABLE_LOGGING = false`
- [ ] Set `ENABLE_MOCK_DATA = false`
- [ ] Set `ENABLE_SSL_PINNING = true`
- [ ] Set `ENABLE_APP_SIGNING = true`

## 🎉 **Benefits**

✅ **Single Source of Truth**: All configs in one file
✅ **Easy Management**: Change settings without code hunting
✅ **Environment Aware**: Automatic URL switching
✅ **Feature Flags**: Toggle features on/off easily
✅ **Type Safe**: Strongly typed configuration
✅ **Scalable**: Add new configs easily
✅ **Maintainable**: Clear structure and documentation

## 🔄 **Migration from Old System**

The old configuration system is still compatible, but now you can:
1. Use `AppConfig.AUTH_SERVICE` instead of `AuthConfig.general.defaultAuthService`
2. Use `AppConfig.PHONE_AUTH_TIMEOUT` instead of hardcoded values
3. Use `AppConfig.isFeatureEnabled('feature_name')` for feature checks

Your app is now fully configurable from one central location! 🚀

