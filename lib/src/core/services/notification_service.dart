
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
<<<<<<< Updated upstream
=======
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:leam/generated/assets.dart';
import 'package:leam/src/core/config/di/service_locator.dart';
>>>>>>> Stashed changes

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService{

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static final NotificationService instance = NotificationService._();

  NotificationService._();

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

<<<<<<< Updated upstream
=======
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      if (firebaseAuth.currentUser != null) {
        await firebaseFirestore
            .collection("users")
            .doc(firebaseAuth.currentUser?.uid)
            .update({"fcmToken": token});
      }
    });
>>>>>>> Stashed changes
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (kDebugMode) {
      print('Permission status: ${settings.authorizationStatus}');
    }
  }


  Future<void> setupFlutterNotifications() async {
    // android setup
    const channel = AndroidNotificationChannel(
      'Leam Message Channel',
      'Message',
      description: 'This channel is used for receive message notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
    >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // ios setup
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Leam Message Channel',
            'Message',
            channelDescription:
            'This channel is used for receive message notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a background message: ${message.data}');

    //  AppRoutes.router.go(AppRoutes.notification);
    }

    showNotification(message);
  }

<<<<<<< Updated upstream
}
=======
  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
    String userFcmToken,
    String title,
    String message,
  ) async {
    try {
      final body = {
        "message": {
          "token": userFcmToken,
          "notification": {"title": title, "body": message},
        },
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'leam-c34ea';

      // get firebase admin token
      final bearerToken = await _getAccessToken();

      // handle null token
      if (bearerToken == null) return;

      var response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Notification sent successfully!');
        }
      } else {
        if (kDebugMode) {
          print(
            '❌ Failed to send notification: ${response.statusCode} ${response.body}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error sending push notification: $e');
      }
    }
  }

  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final filePath = await rootBundle.loadString(
        Assets.filesLeamFirebasePrivateKey,
      );

      final json = jsonDecode(filePath);

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(json),
        [fMessagingScope],
      );

      return client.credentials.accessToken.data;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return null;
    }
  }
}
>>>>>>> Stashed changes
