# Firebase Setup Guide for Auramate

## 🔥 Firebase Configuration

The app is now configured with Firebase authentication for phone OTP verification. Here's how to set up Firebase properly:

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `auramate` (or your preferred name)
4. Follow the setup wizard

### 2. Enable Phone Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Sign-in method** tab
3. Enable **Phone** provider
4. Add your test phone numbers (for development)

### 3. Get Firebase Configuration

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **Your apps** section
3. Click **Add app** and select your platform (Android/iOS/Web)
4. Download the configuration files:
   - **Android**: `google-services.json`
   - **iOS**: `GoogleService-Info.plist`
   - **Web**: Copy the config object

### 4. Update Configuration Files

#### For Android:
1. Place `google-services.json` in `android/app/`
2. Add to `android/build.gradle`:
   ```gradle
   classpath 'com.google.gms:google-services:4.3.15'
   ```
3. Add to `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### For iOS:
1. Place `GoogleService-Info.plist` in `ios/Runner/`
2. Add to Xcode project

#### For Web:
1. Update `lib/firebase_options.dart` with your actual config values

### 5. Update Firebase Options

Replace the dummy values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: 'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'YOUR_ACTUAL_PROJECT_ID',
  authDomain: 'YOUR_ACTUAL_AUTH_DOMAIN',
  storageBucket: 'YOUR_ACTUAL_STORAGE_BUCKET',
);
```

### 6. Test Phone Authentication

1. Run the app: `flutter run`
2. Navigate to phone entry screen
3. Enter a test phone number
4. You should receive an SMS with verification code
5. Enter the code to verify

### 7. Production Setup

For production:
1. Remove test phone numbers from Firebase Console
2. Enable app verification (SafetyNet for Android, App Check for iOS)
3. Set up proper security rules
4. Configure billing for SMS costs

## 🔧 Current Implementation

The Firebase authentication service is now fully implemented with:

- ✅ Phone number verification
- ✅ OTP code verification
- ✅ Error handling for various scenarios
- ✅ User session management
- ✅ Sign out functionality

## 📱 Features

- **Phone Authentication**: Send OTP to any phone number
- **Auto-verification**: Automatically verifies on some devices
- **Manual verification**: Enter OTP code manually
- **Error handling**: Proper error messages for failed attempts
- **Session management**: Maintains user login state

## 🚀 Next Steps

1. Set up your actual Firebase project
2. Replace dummy configuration with real values
3. Test with real phone numbers
4. Implement additional authentication methods (Google, Apple, etc.)
5. Add user profile management
6. Set up Firebase Firestore for user data

## ⚠️ Important Notes

- Phone authentication incurs SMS costs
- Test thoroughly before production
- Follow Firebase security best practices
- Consider implementing rate limiting
- Set up proper error monitoring

## 🆘 Troubleshooting

If you encounter issues:

1. **Firebase not initialized**: Check `main.dart` Firebase initialization
2. **Phone auth not working**: Verify Firebase Console settings
3. **SMS not received**: Check test phone numbers in Firebase Console
4. **Verification failed**: Check error messages in console

For more help, refer to [Firebase Phone Auth Documentation](https://firebase.google.com/docs/auth/flutter/phone-auth).

