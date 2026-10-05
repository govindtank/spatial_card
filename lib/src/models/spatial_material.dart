import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Defines the surface texture, specular reflectivity, and chromatic sheen
/// of a [SpatialCard].
class SpatialMaterial {
  /// Base background gradient of the card surface.
  final Gradient backgroundGradient;

  /// Intensity of the dynamic specular glare (0.0 = none, 1.0 = standard, 2.0 = bright).
  final double specularIntensity;

  /// Radius of the specular light point in fraction of card size (default 0.6).
  final double specularRadius;

  /// Strength of the rainbow chromatic dispersion / holographic foil effect (0.0 to 1.0).
  final double chromaticDispersion;

  /// Base angle (in radians) for chromatic sheen streaks.
  final double sheenAngle;

  /// Border highlight color.
  final Color borderColor;

  /// Width of the card border.
  final double borderWidth;

  /// Color of the ambient inner rim highlight.
  final Color innerHighlightColor;

  /// Surface texture pattern mode.
  final SurfacePattern pattern;

  /// Base surface color if gradient is not fully opaque.
  final Color baseColor;

  /// Creates a custom [SpatialMaterial].
  const SpatialMaterial({
    this.backgroundGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    ),
    this.specularIntensity = 0.8,
    this.specularRadius = 0.65,
    this.chromaticDispersion = 0.0,
    this.sheenAngle = math.pi / 4,
    this.borderColor = const Color(0x33FFFFFF),
    this.borderWidth = 1.0,
    this.innerHighlightColor = const Color(0x22FFFFFF),
    this.pattern = SurfacePattern.smooth,
    this.baseColor = const Color(0xFF0F172A),
  });

  /// Holographic foil preset with iridescent rainbow dispersion and vibrant sheen.
  factory SpatialMaterial.holographicFoil({
    Gradient? customGradient,
    double specularIntensity = 1.1,
    double chromaticDispersion = 0.85,
  }) {
    return SpatialMaterial(
      backgroundGradient:
          customGradient ??
          const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1035), Color(0xFF0E1A38), Color(0xFF0A0F1D)],
          ),
      specularIntensity: specularIntensity,
      specularRadius: 0.75,
      chromaticDispersion: chromaticDispersion,
      sheenAngle: 1.15,
      borderColor: const Color(0x66A78BFA),
      borderWidth: 1.2,
      innerHighlightColor: const Color(0x4438BDF8),
      pattern: SurfacePattern.holographic,
      baseColor: const Color(0xFF0F172A),
    );
  }

  /// Brushed titanium preset with subtle horizontal micro-grooves and focused glare (Apple Card style).
  factory SpatialMaterial.brushedTitanium({
    Color baseTone = const Color(0xFF1E2530),
    double specularIntensity = 0.85,
  }) {
    return SpatialMaterial(
      backgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [baseTone, const Color(0xFF141A22), const Color(0xFF0D1117)],
      ),
      specularIntensity: specularIntensity,
      specularRadius: 0.55,
      chromaticDispersion: 0.1,
      sheenAngle: math.pi / 3,
      borderColor: const Color(0x44E2E8F0),
      borderWidth: 1.0,
      innerHighlightColor: const Color(0x33FFFFFF),
      pattern: SurfacePattern.brushedMetal,
      baseColor: baseTone,
    );
  }

  /// Translucent frosted obsidian glass preset with diffuse ambient glow.
  factory SpatialMaterial.frostedGlass({
    Color glassTint = const Color(0x22FFFFFF),
    double specularIntensity = 0.9,
  }) {
    return SpatialMaterial(
      backgroundGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [glassTint, const Color(0x0AFFFFFF), const Color(0x14000000)],
      ),
      specularIntensity: specularIntensity,
      specularRadius: 0.8,
      chromaticDispersion: 0.25,
      sheenAngle: math.pi / 4,
      borderColor: const Color(0x55FFFFFF),
      borderWidth: 1.2,
      innerHighlightColor: const Color(0x40FFFFFF),
      pattern: SurfacePattern.frostedGlass,
      baseColor: const Color(0x15000000),
    );
  }

  /// Cyber neon preset with vibrant cyan/magenta rim lighting.
  factory SpatialMaterial.cyberNeon({
    Color neonColor = const Color(0xFF00F0FF),
    Color accentColor = const Color(0xFFFF007A),
  }) {
    return SpatialMaterial(
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0B132B), Color(0xFF1C2541), Color(0xFF050811)],
      ),
      specularIntensity: 1.2,
      specularRadius: 0.7,
      chromaticDispersion: 0.6,
      sheenAngle: 0.9,
      borderColor: neonColor.withValues(alpha: 0.6),
      borderWidth: 1.5,
      innerHighlightColor: accentColor.withValues(alpha: 0.35),
      pattern: SurfacePattern.cyberGrid,
      baseColor: const Color(0xFF050811),
    );
  }

  /// Carbon fiber weave pattern with anisotropic specular sheen.
  factory SpatialMaterial.carbonFiber({double specularIntensity = 0.75}) {
    return SpatialMaterial(
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF18181B), Color(0xFF09090B), Color(0xFF000000)],
      ),
      specularIntensity: specularIntensity,
      specularRadius: 0.5,
      chromaticDispersion: 0.05,
      sheenAngle: math.pi / 4,
      borderColor: const Color(0x33A1A1AA),
      borderWidth: 1.0,
      innerHighlightColor: const Color(0x22FFFFFF),
      pattern: SurfacePattern.carbonFiber,
      baseColor: const Color(0xFF09090B),
    );
  }

  /// Polished gold foil with warm metallic reflections.
  factory SpatialMaterial.goldFoil({double specularIntensity = 1.15}) {
    return SpatialMaterial(
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD4AF37), Color(0xFFAA7A1E), Color(0xFF5A3E09)],
      ),
      specularIntensity: specularIntensity,
      specularRadius: 0.65,
      chromaticDispersion: 0.35,
      sheenAngle: math.pi / 3.5,
      borderColor: const Color(0x88FFE082),
      borderWidth: 1.4,
      innerHighlightColor: const Color(0x55FFF8E1),
      pattern: SurfacePattern.goldFoil,
      baseColor: const Color(0xFF5A3E09),
    );
  }

  /// Copies this material with optional parameter overrides.
  SpatialMaterial copyWith({
    Gradient? backgroundGradient,
    double? specularIntensity,
    double? specularRadius,
    double? chromaticDispersion,
    double? sheenAngle,
    Color? borderColor,
    double? borderWidth,
    Color? innerHighlightColor,
    SurfacePattern? pattern,
    Color? baseColor,
  }) {
    return SpatialMaterial(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      specularIntensity: specularIntensity ?? this.specularIntensity,
      specularRadius: specularRadius ?? this.specularRadius,
      chromaticDispersion: chromaticDispersion ?? this.chromaticDispersion,
      sheenAngle: sheenAngle ?? this.sheenAngle,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      innerHighlightColor: innerHighlightColor ?? this.innerHighlightColor,
      pattern: pattern ?? this.pattern,
      baseColor: baseColor ?? this.baseColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpatialMaterial &&
          backgroundGradient == other.backgroundGradient &&
          specularIntensity == other.specularIntensity &&
          specularRadius == other.specularRadius &&
          chromaticDispersion == other.chromaticDispersion &&
          sheenAngle == other.sheenAngle &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth &&
          innerHighlightColor == other.innerHighlightColor &&
          pattern == other.pattern &&
          baseColor == other.baseColor);

  @override
  int get hashCode => Object.hash(
    backgroundGradient,
    specularIntensity,
    specularRadius,
    chromaticDispersion,
    sheenAngle,
    borderColor,
    borderWidth,
    innerHighlightColor,
    pattern,
    baseColor,
  );
}

/// Surface micro-texture patterns rendered onto the material base.
enum SurfacePattern {
  /// Clean, uniform smooth surface.
  smooth,

  /// Fine horizontal or diagonal micro-grooves.
  brushedMetal,

  /// Prismatic diffractive holographic grating.
  holographic,

  /// Diffuse translucent glass diffusion.
  frostedGlass,

  /// Digital vector cybernetic grid.
  cyberGrid,

  /// Diagonal carbon-fiber weave pattern.
  carbonFiber,

  /// Warm metallic gold leaf reflective flecks.
  goldFoil,
}
