import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Controller for programmatically driving [SpatialCard] tilt, flips, and lighting.
class SpatialController extends ChangeNotifier {
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isFlipped = false;
  double _flipProgress = 0.0;
  bool _isPressed = false;
  bool _isDisposed = false;

  /// Current normalized tilt along horizontal axis (range `[-1.0, 1.0]`).
  double get tiltX => _tiltX;

  /// Current normalized tilt along vertical axis (range `[-1.0, 1.0]`).
  double get tiltY => _tiltY;

  /// Whether the card is currently displaying its back face.
  bool get isFlipped => _isFlipped;

  /// Normalized flip rotation progress (`0.0` = front, `1.0` = back).
  double get flipProgress => _flipProgress;

  /// Whether the card is currently being pressed down by a pointer.
  bool get isPressed => _isPressed;

  /// Creates a [SpatialController].
  SpatialController({
    double initialTiltX = 0.0,
    double initialTiltY = 0.0,
    bool initiallyFlipped = false,
  })  : _tiltX = initialTiltX,
        _tiltY = initialTiltY,
        _isFlipped = initiallyFlipped,
        _flipProgress = initiallyFlipped ? 1.0 : 0.0;

  /// Sets the 2D tilt coordinates directly in normalized space (`[-1.0, 1.0]`).
  void setTilt(double x, double y) {
    if (_isDisposed) {
      return;
    }
    final clampedX = x.clamp(-1.0, 1.0);
    final clampedY = y.clamp(-1.0, 1.0);
    if (_tiltX != clampedX || _tiltY != clampedY) {
      _tiltX = clampedX;
      _tiltY = clampedY;
      notifyListeners();
    }
  }

  /// Sets the press state of the card.
  void setPressed(bool pressed) {
    if (_isDisposed) {
      return;
    }
    if (_isPressed != pressed) {
      _isPressed = pressed;
      notifyListeners();
    }
  }

  /// Updates the normalized flip progress (`0.0` to `1.0`).
  void setFlipProgress(double progress) {
    if (_isDisposed) {
      return;
    }
    final clamped = progress.clamp(0.0, 1.0);
    if (_flipProgress != clamped) {
      _flipProgress = clamped;
      _isFlipped = clamped >= 0.5;
      notifyListeners();
    }
  }

  /// Toggles the flip state between front and back.
  void toggleFlip() {
    if (_isDisposed) {
      return;
    }
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  /// Resets tilt coordinates back to level center `(0.0, 0.0)`.
  void resetTilt() {
    setTilt(0.0, 0.0);
  }

  /// Triggers a light micro-haptic impact if supported.
  void triggerHaptic() {
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
