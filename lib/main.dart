import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fe/services/fcm_notification_service.dart';
import 'package:cote_network_logger/cote_network_logger.dart';
import 'package:fe/firebase_options.dart';
import 'app.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startNetworkLogServer();
  await RiveNative.init();

  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('⚠️ Firebase initialization failed: $e');
    }
  } else {
    print('⚠️ Firebase not initialized on Web platform');
  }

  runApp(const ProviderScope(child: MyApp()));
}
