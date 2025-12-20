import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:leam/src/config/di/service_locator.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static final NotificationService instance = NotificationService._();

  NotificationService._();

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    if (firebaseAuth.currentUser != null) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await firebaseFirestore
            .collection("users")
            .doc(firebaseAuth.currentUser?.uid)
            .update({"fcmToken": token});
      });
    }
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
    showNotification(message);
  }

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
      const projectID = 'leam-dc054';

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

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "leam-dc054",
          "private_key_id": "0981a17120c6b3517ef471365d07c6d1c4d7c12a",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCoz2xXAmaUZ6E5\nV43cAbMMOtr9gMKG1TkQgWtY9d9weukxWTp+UXjXvyIxgxvPu0m2pqnQpJBoxy55\nzm2xoXWEcQallt4PjebAF5+pvVoo0f+7ao4gIS0ABkSco8lOD0bvcei47b/vv2+I\nk47p5b7kC22mPNGl8mhoG8HUtz2bugvto2ahSzwU1Xrrqh91LHZxGIyK7/LZgCrn\nqnhhIwEMrE4FBuRDQzpVrivyd8iOvJgTJeC+mph8yNu89On0HutK/31s23mvysRp\nqfwD+nRFIia6YFhEzOAXo5A6NiBwSlhR6LKnzEY90Fe8LXBH301WeT8CNVPZEg5i\nul8u+G7FAgMBAAECggEACWJ8rqqkwB0xwUcXjR1avPQ8WUmyUX4i8xgK0HzczDtH\ntwqznd2oJvBf4C+eg8eGTdKepV7cuLfSuDVXHlVa++mvrv7VP2P0vzBLsUtPAEQf\nyuVzMMs/XfK7QkJjGNqbEjPmNk+2CF1Uv/DvdJvlPKF7r06kG20U9lgNXXwcFJ86\n/CNjpmbPAdjJndUoNfdE0S4RKeLu9AEzW26Wd0yl1JaH6BGbirebPHaQslHAili9\n65KcIm2igKxf0MAmKLZWHUIo3BI4T2IeMSGB6tMilGO00l/3eGjSQQlyxvIvAZJz\nfEn6AohA9U+sMQXBNgz4jI4IuZ/X13UBNXr5z+bzQQKBgQDafrR5EgJqtl9o8Ivm\nJPl9r9Hdk3Qjmji5pYQh4P3zuC61msM6Mvfx4EsZ7/VJ/UKp5OUDXC8oC1o8ig0e\nRjAQ5dECQQHjPJdFQwOF9UCxjCnER81nPrZpxyGihzR5Yn1FcyKGrN3kQtmyiKOu\nJ1rOQSFDsQZO5VZH5uegGpFrwQKBgQDFyW4bxFYiJM6C6+GB0pkpf4j0AQzc2nmX\nVP761Pftg2bBEr53PvrRGVmA1ePZShMKKh4O13FLJYPUoak/7ETbO1N9d8moayY5\nKBycsOD/eDs+Qwsyb7Dxai447ImiPw2W3f3+LemTgX3hHeCTfc8jhaeGJChLQlWS\nKWQSfEZUBQKBgQDDXGM1lZq/m403oU0VXJ4PeXNmcP95Dd4GcC3ytN+cWWS6UESa\n9xOnG2tLJ7jkjSRcECOMm5I2deAbHTyZgxxbH4GASGvNqFGBRmgSELXlinOV4rWP\nyQ0FC13Rmp6aoitsO4P1cv97pyJLdc0UXG/e13FMuy3uwTQiWh1klBzOgQKBgBno\nthTLFmFooujBj4vbE5c9DqqwDIhN0knBp5kiFsw1P1uhYfPq+x4zDOd0nWFUc8QM\nGl3lWQD4DBnph2tJPwfc8KXp8C+wwZQRLhZUkVTF4jTYwXm86dfmCeIJEkp/qf8O\nW3xVdViOSPgZWtbXTzAfDP/kcqbRLLZ115cYUnolAoGBANFpBz5e83XnV4/oZN7h\nPah7aO7u+Pjm2MPC8R2UcLeaPh8Q27N1OrDftmv2afDpvZDcHEYWdp64I4VhBNks\n7eDkVt8LGz1aZMYxzN4Xlnpjxv6q3AaP5Qhc76SDBbWac2gi421tAc8AfZ4D2c2V\nIZasjbYQg1sXzrAoknQp1Fh4\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@leam-dc054.iam.gserviceaccount.com",
          "client_id": "117459222098716955083",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40leam-dc054.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com",
        }),
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
