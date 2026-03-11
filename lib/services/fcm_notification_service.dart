import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fe/pages/group/chatGroupPage.dart';
import 'package:fe/pages/group/repository/group_repository.dart';
import 'package:fe/services/navigation_service.dart';
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📱 Background Message: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

class FCMNotificationService {
  FCMNotificationService._internal();
  static final FCMNotificationService _instance =
      FCMNotificationService._internal();
  factory FCMNotificationService() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _storage = const FlutterSecureStorage();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _chatChannel =
      AndroidNotificationChannel(
    'chat_messages',
    'Chat Messages',
    description: 'Notifications for chat messages',
    importance: Importance.high,
  );

  // Stream Controllers
  final _messageController = StreamController<RemoteMessage>.broadcast();
  final _tokenController = StreamController<String>.broadcast();

  // Public Streams
  Stream<RemoteMessage> get messageStream => _messageController.stream;
  Stream<String> get tokenStream => _tokenController.stream;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  bool _isInitialized = false;
  bool _isRetrySyncScheduled = false;
  bool _isTokenRecoveryScheduled = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await _initializeLocalNotifications();

      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('📱 FCM Permission Status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ User granted notification permission');

        await _getFCMToken();

        if (Platform.isIOS) {
          _scheduleIOSRetrySync();
        }
        _setupListeners();

        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        _isInitialized = true;
      } else {
        print('❌ User declined notification permission');
      }
    } catch (e) {
      print('🔴 FCM Initialization Error: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_chatChannel);

    if (Platform.isAndroid) {
      final granted = await androidPlugin?.requestNotificationsPermission();
      print('📱 Android notification permission: $granted');
    }
  }

  /// Get and Save FCM Token
  Future<void> _getFCMToken() async {
    try {
      if (Platform.isIOS) {
        final apnsReady = await _waitForAPNsToken();
        if (!apnsReady) {
          print('⚠️ APNS token not ready yet, skip initial FCM token fetch');
          return;
        }
      }

      _fcmToken = await _getTokenWithRetry();

      if (_fcmToken != null) {
        print('📱 FCM Token: $_fcmToken');
        await _storage.write(key: 'fcm_token', value: _fcmToken);
        _tokenController.add(_fcmToken!);

        // Send token to backend
        await _sendTokenToBackend(_fcmToken!);
      }
    } catch (e) {
      print('🔴 Error getting FCM token: $e');
      if (_isTransientFcmError(e)) {
        _scheduleTokenRecovery();
      }
    }
  }

  /// Force sync current token to backend (use after login)
  Future<void> syncTokenWithBackend() async {
    try {
      if (Platform.isIOS) {
        final apnsReady = await _waitForAPNsToken();
        if (!apnsReady) {
          print('⚠️ APNS token not ready after login, skip FCM sync for now');
          _scheduleIOSRetrySync();
          return;
        }
      }

      final token = _fcmToken ?? await _getTokenWithRetry();
      if (token == null || token.isEmpty) {
        print('⚠️ No FCM token available for sync');
        return;
      }

      _fcmToken = token;
      await _storage.write(key: 'fcm_token', value: token);
      await _sendTokenToBackend(token);
    } catch (e) {
      print('🔴 Error syncing FCM token after login: $e');
    }
  }

  Future<String?> _getTokenWithRetry({int maxAttempts = 4}) async {
    Object? lastError;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _firebaseMessaging.getToken();
      } catch (e) {
        lastError = e;
        final shouldRetry = _isTransientFcmError(e);

        if (!shouldRetry || attempt == maxAttempts) {
          rethrow;
        }

        final delay = Duration(milliseconds: 700 * attempt);
        print(
          '⚠️ FCM token fetch failed (attempt $attempt/$maxAttempts), retrying in ${delay.inMilliseconds}ms: $e',
        );
        await Future.delayed(delay);
      }
    }

    throw lastError ?? Exception('Unable to get FCM token');
  }

  bool _isTransientFcmError(Object error) {
    final errorText = error.toString();
    return errorText.contains('SERVICE_NOT_AVAILABLE') ||
        errorText.contains('FirebaseInstallationsException') ||
        errorText.contains('Service is unavailable') ||
        errorText.contains('java.io.IOException');
  }

  void _scheduleTokenRecovery() {
    if (_isTokenRecoveryScheduled) {
      return;
    }

    _isTokenRecoveryScheduled = true;
    Future<void>(() async {
      for (var i = 1; i <= 6; i++) {
        await Future.delayed(Duration(seconds: 10 * i));

        try {
          final recoveredToken = await _getTokenWithRetry();
          if (recoveredToken == null || recoveredToken.isEmpty) {
            continue;
          }

          _fcmToken = recoveredToken;
          await _storage.write(key: 'fcm_token', value: recoveredToken);
          _tokenController.add(recoveredToken);
          await _sendTokenToBackend(recoveredToken);
          print('✅ Recovered FCM token after transient service issue');
          _isTokenRecoveryScheduled = false;
          return;
        } catch (e) {
          print('⚠️ FCM recovery attempt $i failed: $e');
          if (!_isTransientFcmError(e)) {
            break;
          }
        }
      }

      _isTokenRecoveryScheduled = false;
    });
  }

  Future<bool> _waitForAPNsToken({int maxAttempts = 10}) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null && apnsToken.isNotEmpty) {
        print('✅ APNS token is ready');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  void _scheduleIOSRetrySync() {
    if (!Platform.isIOS || _isRetrySyncScheduled) {
      return;
    }

    _isRetrySyncScheduled = true;
    Future<void>(() async {
      for (var i = 0; i < 6; i++) {
        await Future.delayed(const Duration(seconds: 5));
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          print('✅ APNS token became ready, retrying FCM sync');
          await syncTokenWithBackend();
          _isRetrySyncScheduled = false;
          return;
        }
      }
      _isRetrySyncScheduled = false;
    });
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground Message Received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');

      _showForegroundNotification(message);
      _messageController.add(message);

      if (message.data['type'] == 'chat_message') {
        _handleChatNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 Notification Tapped (Background)');
      print('Data: ${message.data}');

      _handleNotificationTap(message);
    });

    // Token Refresh
    _firebaseMessaging.onTokenRefresh.listen((String newToken) {
      print('🔄 FCM Token Refreshed: $newToken');
      _fcmToken = newToken;
      _storage.write(key: 'fcm_token', value: newToken);
      _tokenController.add(newToken);
      _sendTokenToBackend(newToken);
    });
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title = message.notification?.title ??
        (message.data['title']?.toString() ?? 'New notification');
    final body = message.notification?.body ??
        (message.data['body']?.toString() ?? 'You have a new message');

    await _localNotifications.show(
      title.hashCode ^ body.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_messages',
          'Chat Messages',
          channelDescription: 'Notifications for chat messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Send FCM Token to Backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final authToken = await _storage.read(key: 'token');
      if (authToken == null) {
        print('⚠️ No auth token found, skipping FCM token upload');
        return;
      }

      final wsUrl = dotenv.env['WEBSOCKET_URL'];
      final baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
      final deviceType = Platform.isIOS ? 'ios' : 'android';
      final deviceId = '${deviceType}_${token.substring(0, 12)}';

      final registerPayload = jsonEncode({
        'token': token,
        'device_type': deviceType,
        'device_id': deviceId,
      });

      final candidateBases = <String>[];
      if (wsUrl != null && wsUrl.isNotEmpty) {
        final wsUri = Uri.tryParse(wsUrl);
        if (wsUri != null && wsUri.host.isNotEmpty) {
          final wsHttpScheme = wsUri.scheme == 'wss' ? 'https' : 'http';
          candidateBases.add('$wsHttpScheme://${wsUri.authority}');
        }
      }
      candidateBases.add(baseUrl);

      final seen = <String>{};
      final uniqueBases = candidateBases.where((b) => seen.add(b)).toList();

      for (final serviceBase in uniqueBases) {
        final v1Response = await http.post(
          Uri.parse('$serviceBase/api/v1/fcm/register'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: registerPayload,
        );

        if (v1Response.statusCode >= 200 && v1Response.statusCode < 300) {
          print('✅ FCM token registered via $serviceBase/api/v1/fcm/register');
          return;
        }

        final compatResponse = await http.post(
          Uri.parse('$serviceBase/api/fcm/register'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: registerPayload,
        );

        if (compatResponse.statusCode >= 200 &&
            compatResponse.statusCode < 300) {
          print('✅ FCM token registered via $serviceBase/api/fcm/register');
          return;
        }

        print(
          '⚠️ FCM register endpoint not found on $serviceBase. v1=${v1Response.statusCode}, compat=${compatResponse.statusCode}',
        );
      }

      print('❌ Failed to register FCM token on all configured services');
    } catch (e) {
      print('🔴 Error sending FCM token to backend: $e');
    }
  }

  void _handleChatNotification(RemoteMessage message) {
    final groupId = message.data['group_id'];
    final messageText = message.data['message'];
    final senderName = message.data['sender_name'] ?? 'Member';
    final groupName = message.data['group_name'] ?? 'Group';

    print('💬 Chat Message - Group: $groupId, Message: $messageText');

    _showLocalNotification(senderName, groupName, messageText);
  }

  Future<void> _showLocalNotification(
    String senderName,
    String groupName,
    String messageText,
  ) async {
    try {
      final title = '$senderName ($groupName)';
      final body = messageText;

      await _localNotifications.show(
        DateTime.now().millisecond,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _chatChannel.id,
            _chatChannel.name,
            channelDescription: _chatChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      print('🔴 Error showing local notification: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = message.data['type'];
    final groupId = message.data['group_id']?.toString();

    print('👆 Notification Tapped - Type: $type, Group: $groupId');

    if (type != 'chat_message' || groupId == null || groupId.isEmpty) {
      return;
    }

    Future<void>(() async {
      try {
        final group = await GroupRepository().getGroup(groupId);
        final navigator = AppNavigationService.navigatorKey.currentState;
        if (navigator == null) {
          print('⚠️ Navigator is not ready for notification navigation');
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) => ChatGroupPage(group: group),
          ),
        );
      } catch (e) {
        print('🔴 Failed to navigate from notification: $e');
      }
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('🔴 Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('🔴 Error unsubscribing from topic: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      await _storage.delete(key: 'fcm_token');
      _fcmToken = null;
      print('✅ FCM Token deleted');
    } catch (e) {
      print('🔴 Error deleting FCM token: $e');
    }
  }

  void dispose() {
    _messageController.close();
    _tokenController.close();
  }
}
