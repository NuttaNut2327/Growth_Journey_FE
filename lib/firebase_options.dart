import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzN-TXep5_L6Mdwzzmk3cWdo0TFcCaPjs',
    appId: '1:274714575227:android:b85166fccc9667c633fdde',
    messagingSenderId: '274714575227',
    projectId: 'graceful-cider-486915-i4',
    storageBucket: 'graceful-cider-486915-i4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2BWq2xOELbnbNTEK8bmUzLHEYl-0YGG4',
    appId: '1:159046432282:ios:d04333730b0588e27d43a3',
    messagingSenderId: '159046432282',
    projectId: 'growth-journal-ea7d8',
    storageBucket: 'growth-journal-ea7d8.firebasestorage.app',
    iosBundleId: 'com.yuukakawai.growthjournal',
  );
}
