import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:think_flow/firebase_options.dart';
import 'package:think_flow/services/firebase_messaging_service.dart';
import 'package:think_flow/services/local_notifications_service.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);

  runApp(App());
}
