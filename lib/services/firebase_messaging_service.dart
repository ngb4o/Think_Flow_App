import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:think_flow/services/local_notifications_service.dart';
import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'dart:io' show Platform;
import 'package:think_flow/utils/utils.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;
  final _apiClient = ApiClient();
  String? _pendingFCMToken;
  String? _deviceId;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Get device ID
    await _initDeviceId();

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _initDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    }
    print('Device ID: $_deviceId');
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await FirebaseMessaging.instance.getToken();
    print('Push notifications token: $token');

    if (token != null) {
      // Check if user is logged in before registering token
      final cookie = await Utils.getCookie();
      if (cookie != null) {
        await _registerFCMToken(token);
      } else {
        // Store token for later registration
        _pendingFCMToken = token;
        print('User not logged in, storing FCM token for later registration');
      }
    }

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      print('FCM token refreshed: $fcmToken');
      // Check if user is logged in before registering new token
      final cookie = await Utils.getCookie();
      if (cookie != null) {
        await _registerFCMToken(fcmToken);
      } else {
        // Store new token for later registration
        _pendingFCMToken = fcmToken;
        print('User not logged in, storing new FCM token for later registration');
      }
    }).onError((error) {
      print('Error refreshing FCM token: $error');
    });
  }

  /// Register pending FCM token after user login
  Future<void> registerPendingToken() async {
    if (_pendingFCMToken != null) {
      print('Registering pending FCM token after login');
      await _registerFCMToken(_pendingFCMToken!);
      _pendingFCMToken = null;
    }
  }

  Future<void> _registerFCMToken(String token) async {
    try {
      final response = await _apiClient.postRequest(
        path: '/notification/v1/notifications/fcm-token',
        body: {
          'token': token,
          'device_id': _deviceId ?? 'unknown-device',
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      print('FCM token registered successfully: ${response.data}');
    } catch (e) {
      // Check if error is due to duplicate token
      if (e.toString().contains('Duplicate entry')) {
        print('FCM token already registered');
      } else {
        print('Error registering FCM token: $e');
      }
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationsService?.showNotification(
          notificationData.title, notificationData.body, message.data.toString());
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}