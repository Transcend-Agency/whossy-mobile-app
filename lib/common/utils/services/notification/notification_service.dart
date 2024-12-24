import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _instance = NotificationService._internal();
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;
  NotificationService._internal();

  final String icon = 'icon';
  final Priority androidPriority = Priority.high;
  final String groupKey = 'com.whossy.whossy_app';
  final String threadId = 'whossy_notifications';

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    'whossy_channel',
    'whossy_notifications',
    importance: Importance.max,
    description: 'This channel is used for Whossy notifications',
  );

  NotificationDetails getNotificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        importance: _androidChannel.importance,
        priority: androidPriority,
        channelDescription: _androidChannel.description,
        icon: icon,
        groupKey: groupKey,
      ),
      iOS: DarwinNotificationDetails(threadIdentifier: threadId),
    );
  }

  Future<void> init() async {
    await _messaging.requestPermission().then((value) =>
        log('Notification authorization status: ${value.authorizationStatus}'));

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await initPushNotifications();
    await initLocalNotifications();
  }

  Future<String> getToken() async => (await _messaging.getToken()) ?? '';
  Future<void> deleteToken() async => await _messaging.deleteToken();

  Future<void> initPushNotifications() async {
    _messaging.getInitialMessage().then(handleInitialMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      final notification = event.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        getNotificationDetails(),
        payload: jsonEncode(event.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    final android = AndroidInitializationSettings(icon);
    const iOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.createNotificationChannel(_androidChannel);
    }

    _localNotifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
  }
}

void handleForegroundMessage(RemoteMessage? message) {
  if (message == null) return;
}

void handleInitialMessage(RemoteMessage? message) {
  if (message == null) return;
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Background message detected');
}

@pragma('vm:entry-point')
Future<void> onDidReceiveNotificationResponse(
  NotificationResponse response,
) async {
  if (response.payload == null) return;

  final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
  handleForegroundMessage(message);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

void onDidReceiveLocalNotification(
  int id,
  String? title,
  String? body,
  String? payload,
) async {}
