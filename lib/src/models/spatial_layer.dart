import 'package:flutter/widgets.dart';

/// Represents an independent visual plane on a [SpatialCard] elevated at a specific Z-depth.
class SpatialLayer {
  /// The depth elevation factor of this layer.
  ///
  /// Standard scale:
  /// - `0.0`: Base surface (no parallax offset).
  /// - `0.3` to `0.5`: Subtle elevation (names, background logos, labels).
  /// - `0.8` to `1.2`: High elevation (EMV chips, card numbers, primary buttons, badges).
  final double depth;

  /// The child widget rendered on this elevation plane.
  final Widget child;

  /// Optional custom 2D offset multiplier (defaults to `Offset(1.0, 1.0)`).
  final Offset offsetMultiplier;

  /// Whether this layer casts a dynamic soft drop-shadow onto lower layers.
  final bool castShadow;

  /// Custom shadow blur radius (if [castShadow] is true).
  final double shadowBlurRadius;

  /// Custom shadow color.
  final Color shadowColor;

  /// Optional alignment within the card boundaries.
  final AlignmentGeometry? alignment;

  /// Creates a [SpatialLayer].
  const SpatialLayer({
    required this.child,
    this.depth = 0.5,
    this.offsetMultiplier = const Offset(1.0, 1.0),
    this.castShadow = true,
    this.shadowBlurRadius = 8.0,
    this.shadowColor = const Color(0x66000000),
    this.alignment,
  });

  /// Convenience factory for a surface layer at Z=0.
  factory SpatialLayer.base({
    required Widget child,
    AlignmentGeometry? alignment,
  }) {
    return SpatialLayer(
      child: child,
      depth: 0.0,
      castShadow: false,
      alignment: alignment,
    );
  }

  /// Convenience factory for a mid-elevation layer (Z=0.5).
  factory SpatialLayer.mid({
    required Widget child,
    AlignmentGeometry? alignment,
    bool castShadow = true,
  }) {
    return SpatialLayer(
      child: child,
      depth: 0.5,
      castShadow: castShadow,
      shadowBlurRadius: 6.0,
      alignment: alignment,
    );
  }

  /// Convenience factory for a high-elevation layer (Z=1.0).
  factory SpatialLayer.floating({
    required Widget child,
    AlignmentGeometry? alignment,
    bool castShadow = true,
  }) {
    return SpatialLayer(
      child: child,
      depth: 1.0,
      castShadow: castShadow,
      shadowBlurRadius: 12.0,
      alignment: alignment,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpatialLayer &&
          child == other.child &&
          depth == other.depth &&
          offsetMultiplier == other.offsetMultiplier &&
          castShadow == other.castShadow &&
          shadowBlurRadius == other.shadowBlurRadius &&
          shadowColor == other.shadowColor &&
          alignment == other.alignment);

  @override
  int get hashCode => Object.hash(
        child,
        depth,
        offsetMultiplier,
        castShadow,
        shadowBlurRadius,
        shadowColor,
        alignment,
      );
}
