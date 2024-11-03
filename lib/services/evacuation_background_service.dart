import 'dart:async';
import 'dart:ui';

import 'package:exitmatrix/services/ttsservice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EvacuationBackgroundService {
  static final EvacuationBackgroundService _instance = EvacuationBackgroundService._internal();
  factory EvacuationBackgroundService() => _instance;
  EvacuationBackgroundService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final TTSService _ttsService = TTSService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _evacuationSubscription;
  bool _isInitialized = false;
  int? _lastInstructionIndex;

  static const String _channelId = 'evacuation_channel';
  static const String _channelName = 'Evacuation Alerts';
  static const String _channelDescription = 'Emergency Evacuation Guidance';
  
  static const String _nextChannelId = 'next_instruction_channel';
  static const String _nextChannelName = 'Next Instructions';
  static const String _nextChannelDescription = 'Preview of next evacuation instruction';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase already initialized');
    }

    await _initializeNotifications();
    await _ttsService.initialize();
    await _requestNotificationPermissions();

    _isInitialized = true;
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Create main channel for current instructions
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    // Create secondary channel for next instruction previews
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        _nextChannelId,
        _nextChannelName,
        description: _nextChannelDescription,
        importance: Importance.low,
      ),
    );
  }

  Future<void> _requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _handleNotificationTap(NotificationResponse response) {
    // Implement navigation to evacuation screen
  }

  Future<void> startEvacuationMonitoring() async {
    await stopEvacuationMonitoring();

    _evacuationSubscription = _firestore
        .collection('current_map')
        .doc('info')
        .snapshots()
        .listen(_handleEvacuationUpdate);

    await _showEvacuationNotification(
      'Emergency Evacuation',
      'Fire emergency detected. Follow app instructions to evacuate safely.',
    );
  }

  Future<void> stopEvacuationMonitoring() async {
    await _evacuationSubscription?.cancel();
    _evacuationSubscription = null;
    _ttsService.reset();
    _lastInstructionIndex = null;
  }

  Future<void> _handleEvacuationUpdate(DocumentSnapshot snapshot) async {
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;
    
    final buildingName = data['buildingName'] as String?;
    final floorNumber = data['floorNumber'] as int?;
    final warning = data['warning'] as String?;
    final currentInstructionIndex = data['currentInstructionIndex'] as int?;
    final instructions = List<String>.from(data['instructions'] ?? []);

    // Play initial evacuation message if not played yet
    if (!_ttsService.hasPlayedEvacuationMessage && warning != null) {
      final initialMessage = "Emergency evacuation in $buildingName, Floor $floorNumber. $warning";
      await _ttsService.playEvacuationAnnouncement(
        floorNumber?.toString() ?? '',
        initialMessage,
      );
      
      await _showEvacuationNotification(
        'Emergency Warning',
        initialMessage,
      );
    }

    // Handle instruction updates
    if (currentInstructionIndex != null && 
        currentInstructionIndex != _lastInstructionIndex && 
        currentInstructionIndex < instructions.length) {
      
      final currentInstruction = instructions[currentInstructionIndex];
      
      // Special handling for final instruction
      if (currentInstruction == "You have reached the exit") {
        await _ttsService.speakInstruction(
          "You have reached the exit. Please evacuate the building immediately."
        );
        await _showEvacuationNotification(
          'Exit Reached',
          'You have reached the exit. Please evacuate the building immediately.',
        );
      } else {
        await _ttsService.speakInstruction(currentInstruction);
        await _showEvacuationNotification(
          'Current Direction',
          currentInstruction,
        );

        // Show next instruction preview if available
        if (currentInstructionIndex + 1 < instructions.length) {
          final nextInstruction = instructions[currentInstructionIndex + 1];
          await _showNextInstructionNotification(
            'Next Direction',
            'Coming up: $nextInstruction',
          );
        }
      }
      
      _lastInstructionIndex = currentInstructionIndex;
    }
  }

  Future<void> _showEvacuationNotification(String title, String body) async {
    await _notifications.show(
      1, // Fixed ID for main notification
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          color: const Color(0xFFFF0000),
          ledColor: const Color(0xFFFF0000),
          ledOnMs: 1000,
          ledOffMs: 500,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
    );
  }

  Future<void> _showNextInstructionNotification(String title, String body) async {
    await _notifications.show(
      2, // Fixed ID for next instruction preview
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _nextChannelId,
          _nextChannelName,
          channelDescription: _nextChannelDescription,
          importance: Importance.low,
          priority: Priority.low,
          showWhen: false,
          enableLights: false,
          enableVibration: false,
          playSound: false,
          color: const Color(0xFF2196F3), // Blue color for next instruction
          styleInformation: BigTextStyleInformation(
            body,
            htmlFormatContent: true,
            contentTitle: title,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: false,
          interruptionLevel: InterruptionLevel.passive,
        ),
      ),
    );
  }
}