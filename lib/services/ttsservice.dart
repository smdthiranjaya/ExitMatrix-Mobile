import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool hasPlayedEvacuationMessage = false;
  String? _lastSpokenInstruction;

  Future<void> initialize() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    // Configure background audio
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.duckOthers,
      ],
    );
    
    // Setup completion callback
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
  }

  Future<void> playEvacuationAnnouncement(String floorNumber, String message) async {
    if (hasPlayedEvacuationMessage) return;

    if (_isSpeaking) {
      await stop();
    }

    _isSpeaking = true;
    await _flutterTts.speak(message);
    hasPlayedEvacuationMessage = true;
  }

  Future<void> speakInstruction(String instruction) async {
    if (_lastSpokenInstruction != instruction) {
      if (_isSpeaking) {
        await stop();
      }
      _isSpeaking = true;
      await _flutterTts.speak(instruction);
      _lastSpokenInstruction = instruction;
    }
  }

  Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }

  void reset() {
    hasPlayedEvacuationMessage = false;
    _lastSpokenInstruction = null;
  }
}