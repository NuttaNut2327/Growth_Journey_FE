import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static String _requireEnv(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required .env key: $key');
    }
    return value;
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
          'Firebase options have not been configured for web.');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase options are not configured for $defaultTargetPlatform.',
        );
    }
  }

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: _requireEnv('FIREBASE_ANDROID_API_KEY'),
        appId: _requireEnv('FIREBASE_ANDROID_APP_ID'),
        messagingSenderId: _requireEnv('FIREBASE_ANDROID_MESSAGING_SENDER_ID'),
        projectId: _requireEnv('FIREBASE_ANDROID_PROJECT_ID'),
        storageBucket: _requireEnv('FIREBASE_ANDROID_STORAGE_BUCKET'),
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: _requireEnv('FIREBASE_IOS_API_KEY'),
        appId: _requireEnv('FIREBASE_IOS_APP_ID'),
        messagingSenderId: _requireEnv('FIREBASE_IOS_MESSAGING_SENDER_ID'),
        projectId: _requireEnv('FIREBASE_IOS_PROJECT_ID'),
        storageBucket: _requireEnv('FIREBASE_IOS_STORAGE_BUCKET'),
        iosBundleId: _requireEnv('FIREBASE_IOS_BUNDLE_ID'),
      );
}
