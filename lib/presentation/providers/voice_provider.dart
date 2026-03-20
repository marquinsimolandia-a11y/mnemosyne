import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer' as dev;

class VoiceState {
  final bool isListening;
  final String words;
  final double soundLevel;
  final String error;

  VoiceState({
    this.isListening = false,
    this.words = '',
    this.soundLevel = 0.0,
    this.error = '',
  });

  VoiceState copyWith({
    bool? isListening,
    String? words,
    double? soundLevel,
    String? error,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      words: words ?? this.words,
      soundLevel: soundLevel ?? this.soundLevel,
      error: error ?? this.error,
    );
  }
}

class VoiceViewModel extends StateNotifier<VoiceState> {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  VoiceViewModel() : super(VoiceState());

  Future<bool> initSpeech() async {
    try {
      _isAvailable = await _speech.initialize(
        onStatus: (status) {
          dev.log('Speech status: $status');
          if (status == 'notListening' || status == 'done') {
            state = state.copyWith(isListening: false);
          }
        },
        onError: (errorNotification) {
          dev.log('Speech error: $errorNotification');
          state = state.copyWith(
            isListening: false,
            error: errorNotification.errorMsg,
          );
        },
      );
      return _isAvailable;
    } catch (e) {
      dev.log('Speech initialization failed: $e');
      return false;
    }
  }

  void startListening() async {
    if (!_isAvailable) {
      bool initialized = await initSpeech();
      if (!initialized) return;
    }

    state = state.copyWith(isListening: true, words: '', error: '');
    
    await _speech.listen(
      onResult: (result) {
        state = state.copyWith(words: result.recognizedWords);
      },
      onSoundLevelChange: (level) {
        state = state.copyWith(soundLevel: level);
      },
    );
  }

  void stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);
  }
  
  void reset() {
    state = VoiceState();
  }
}

final voiceProvider = StateNotifierProvider<VoiceViewModel, VoiceState>((ref) {
  return VoiceViewModel();
});
