import 'package:flutter/material.dart';
import '../controllers/spatial_controller.dart';
import '../models/spatial_config.dart';
import '../models/spatial_layer.dart';
import '../models/spatial_material.dart';
import 'spatial_card.dart';

/// A lightweight 3D spatial decorator that wraps any arbitrary [child] widget
/// with interactive perspective tilt, specular surface sheen, and tactile dynamics.
class SpatialContainer extends StatelessWidget {
  /// The primary widget content to wrap.
  final Widget child;

  /// Surface material definition.
  final SpatialMaterial material;

  /// Physical perspective and dynamics configuration.
  final SpatialConfig config;

  /// Optional external controller.
  final SpatialController? controller;

  /// Custom width.
  final double? width;

  /// Custom height.
  final double? height;

  /// Corner radius of the container.
  final BorderRadius? borderRadius;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Elevation depth of the child content within the container.
  final double contentDepth;

  /// Creates a [SpatialContainer].
  const SpatialContainer({
    super.key,
    required this.child,
    this.material = const SpatialMaterial(),
    this.config = const SpatialConfig(),
    this.controller,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.contentDepth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return SpatialCard(
      material: material,
      config: config,
      controller: controller,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      layers: [
        SpatialLayer(
          depth: contentDepth,
          castShadow: contentDepth > 0.2,
          child: child,
        ),
      ],
    );
  }
}
