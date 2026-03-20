import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/hash_util.dart';

class PinState {
  final String pin;
  final bool isError;
  final bool isAuthenticated;

  PinState({
    this.pin = '',
    this.isError = false,
    this.isAuthenticated = false,
  });

  PinState copyWith({
    String? pin,
    bool? isError,
    bool? isAuthenticated,
  }) {
    return PinState(
      pin: pin ?? this.pin,
      isError: isError ?? this.isError,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class PinViewModel extends StateNotifier<PinState> {
  PinViewModel() : super(PinState());

  void addDigit(int digit) {
    if (state.pin.length < 4) {
      final newPin = state.pin + digit.toString();
      state = state.copyWith(pin: newPin, isError: false);
      
      if (newPin.length == 4) {
        _validate();
      }
    }
  }

  void removeDigit() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(
        pin: state.pin.substring(0, state.pin.length - 1),
        isError: false,
      );
    }
  }

  void _validate() {
    if (HashUtil.verify(state.pin, kPinHash)) {
      state = state.copyWith(isAuthenticated: true, isError: false);
    } else {
      state = state.copyWith(pin: '', isError: true);
    }
  }

  void resetError() {
    state = state.copyWith(isError: false);
  }
}

final pinProvider = StateNotifierProvider<PinViewModel, PinState>((ref) {
  return PinViewModel();
});
