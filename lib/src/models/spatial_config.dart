import 'package:flutter/widgets.dart';

/// Controls the 3D perspective, tilt limits, lighting, and physical dynamics
/// of a [SpatialCard].
class SpatialConfig {
  /// Maximum tilt angle along the X and Y axes in radians.
  ///
  /// Default is `0.35` (~20 degrees).
  final double maxTiltAngle;

  /// 3D perspective distortion factor (used in `Matrix4.setEntry(3, 2, ...)`).
  ///
  /// Default is `0.0015`. Higher values give dramatic wide-angle perspective.
  final double perspective;

  /// Global multiplier for parallax offset distance across all [SpatialLayer]s.
  ///
  /// Default is `24.0` pixels.
  final double parallaxIntensity;

  /// How much the card depresses along the Z-axis when tapped/pressed (0.0 = none, 0.08 = subtle).
  final double pressDepression;

  /// Scale reduction when pressed down (e.g. 0.98 for subtle tactile squish).
  final double pressScale;

  /// Damping factor for spring snap-back animation when touch/tilt ends (0.0 to 1.0).
  ///
  /// Higher values mean less oscillation / faster settling.
  final double springDamping;

  /// Stiffness of the snap-back spring simulation.
  final double springStiffness;

  /// Whether device micro-haptic feedback is enabled on interaction.
  final bool enableHaptics;

  /// Whether idle ambient breathing / figure-8 light drift is active when untouched.
  final bool enableIdleDrift;

  /// Speed multiplier for idle ambient drift.
  final double idleDriftSpeed;

  /// Radius of the card outer drop-shadow.
  final double outerShadowBlurRadius;

  /// Opacity of the card outer drop-shadow.
  final double outerShadowOpacity;

  /// Corner radius of the card surface.
  final BorderRadius borderRadius;

  /// Direction of light source tracking.
  final LightTrackingMode lightTracking;

  /// Creates a [SpatialConfig] with customizable physical properties.
  const SpatialConfig({
    this.maxTiltAngle = 0.35,
    this.perspective = 0.0015,
    this.parallaxIntensity = 24.0,
    this.pressDepression = 0.06,
    this.pressScale = 0.98,
    this.springDamping = 0.75,
    this.springStiffness = 180.0,
    this.enableHaptics = true,
    this.enableIdleDrift = true,
    this.idleDriftSpeed = 1.0,
    this.outerShadowBlurRadius = 32.0,
    this.outerShadowOpacity = 0.5,
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
    this.lightTracking = LightTrackingMode.touchAndSensor,
  });

  /// Subdued, subtle preset with modest tilt and soft glare.
  factory SpatialConfig.subtle() {
    return const SpatialConfig(
      maxTiltAngle: 0.20,
      perspective: 0.0010,
      parallaxIntensity: 14.0,
      pressDepression: 0.03,
      pressScale: 0.99,
      outerShadowBlurRadius: 20.0,
      outerShadowOpacity: 0.35,
    );
  }

  /// Dramatic, high-depth dynamic preset.
  factory SpatialConfig.immersive() {
    return const SpatialConfig(
      maxTiltAngle: 0.45,
      perspective: 0.0022,
      parallaxIntensity: 36.0,
      pressDepression: 0.08,
      pressScale: 0.96,
      outerShadowBlurRadius: 40.0,
      outerShadowOpacity: 0.65,
    );
  }

  /// Copies this config with optional overrides.
  SpatialConfig copyWith({
    double? maxTiltAngle,
    double? perspective,
    double? parallaxIntensity,
    double? pressDepression,
    double? pressScale,
    double? springDamping,
    double? springStiffness,
    bool? enableHaptics,
    bool? enableIdleDrift,
    double? idleDriftSpeed,
    double? outerShadowBlurRadius,
    double? outerShadowOpacity,
    BorderRadius? borderRadius,
    LightTrackingMode? lightTracking,
  }) {
    return SpatialConfig(
      maxTiltAngle: maxTiltAngle ?? this.maxTiltAngle,
      perspective: perspective ?? this.perspective,
      parallaxIntensity: parallaxIntensity ?? this.parallaxIntensity,
      pressDepression: pressDepression ?? this.pressDepression,
      pressScale: pressScale ?? this.pressScale,
      springDamping: springDamping ?? this.springDamping,
      springStiffness: springStiffness ?? this.springStiffness,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableIdleDrift: enableIdleDrift ?? this.enableIdleDrift,
      idleDriftSpeed: idleDriftSpeed ?? this.idleDriftSpeed,
      outerShadowBlurRadius:
          outerShadowBlurRadius ?? this.outerShadowBlurRadius,
      outerShadowOpacity: outerShadowOpacity ?? this.outerShadowOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      lightTracking: lightTracking ?? this.lightTracking,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpatialConfig &&
          maxTiltAngle == other.maxTiltAngle &&
          perspective == other.perspective &&
          parallaxIntensity == other.parallaxIntensity &&
          pressDepression == other.pressDepression &&
          pressScale == other.pressScale &&
          springDamping == other.springDamping &&
          springStiffness == other.springStiffness &&
          enableHaptics == other.enableHaptics &&
          enableIdleDrift == other.enableIdleDrift &&
          idleDriftSpeed == other.idleDriftSpeed &&
          outerShadowBlurRadius == other.outerShadowBlurRadius &&
          outerShadowOpacity == other.outerShadowOpacity &&
          borderRadius == other.borderRadius &&
          lightTracking == other.lightTracking);

  @override
  int get hashCode => Object.hash(
        maxTiltAngle,
        perspective,
        parallaxIntensity,
        pressDepression,
        pressScale,
        springDamping,
        springStiffness,
        enableHaptics,
        enableIdleDrift,
        idleDriftSpeed,
        outerShadowBlurRadius,
        outerShadowOpacity,
        borderRadius,
        lightTracking,
      );
}

/// Determines what drives the light reflection and 3D tilt coordinates.
enum LightTrackingMode {
  /// Reacts to user touch/pointer movements with idle drift fallback.
  touchAndSensor,

  /// Reacts exclusively to user touch/pointer gestures.
  touchOnly,

  /// Continuously drifts in an ambient figure-8 breathing pattern.
  idleDriftOnly,

  /// Static fixed position without interactive movement.
  fixed,
}
