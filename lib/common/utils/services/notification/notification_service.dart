import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/provider/provider.dart';

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
    await _messaging.requestPermission();
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
    const ios = DarwinInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: ios);

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

    final iosPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}

void _routeToNotificationSubject(Map<String, dynamic> data) {
  final context = appRouter.navigatorKey.currentContext;
  if (context == null) return;

  switch (data['type']) {
    case 'like':
    case 'match':
      final id = data['type'] == 'match' ? data['partnerId'] : data['likerId'];
      if (id == null) return;
      Nav.push(context, NotificationProfilePreview(id: id));
      return;

    case 'message':
      final senderId = data['senderId'];
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (senderId == null || currentUserId == null) return;

      final photo = data['senderProfilePicture'] as String?;

      context.read<ChatsNotifier>().setCurrentChat(
            username: (data['senderName'] as String?) ?? 'User',
            uidUser1: currentUserId,
            uidUser2: senderId,
            profilePicUrl: (photo == null || photo.isEmpty) ? null : photo,
            oppIndex: 1,
          );
      Nav.push(context, const ChatRoom());
      return;

    case 'verification':
      Nav.push(context, const EditProfile());
      return;
  }
}

RemoteMessage? _pendingInitialMessage;

void handleForegroundMessage(RemoteMessage? message) {
  if (message == null) return;
  _routeToNotificationSubject(message.data);
}

void handleInitialMessage(RemoteMessage? message) {
  if (message == null) return;

  if (appRouter.navigatorKey.currentContext == null) {
    _pendingInitialMessage = message;
    return;
  }
  _routeToNotificationSubject(message.data);
}

void consumePendingNotificationLaunch() {
  final message = _pendingInitialMessage;
  if (message == null) return;
  _pendingInitialMessage = null;
  _routeToNotificationSubject(message.data);
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
