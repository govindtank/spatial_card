import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../controllers/spatial_controller.dart';
import '../models/spatial_config.dart';
import '../models/spatial_layer.dart';
import '../models/spatial_material.dart';
import 'spatial_card.dart';

/// Flip axis for [SpatialFlipCard].
enum FlipAxis {
  /// Horizontal flip around the Y-axis.
  horizontal,

  /// Vertical flip around the X-axis.
  vertical,
}

/// A double-sided 3D card widget that smoothly flips between front and back
/// while maintaining continuous 3D perspective and dynamic lighting.
class SpatialFlipCard extends StatefulWidget {
  /// Front face surface material.
  final SpatialMaterial frontMaterial;

  /// Back face surface material.
  final SpatialMaterial? backMaterial;

  /// Front face depth layers.
  final List<SpatialLayer> frontLayers;

  /// Back face depth layers.
  final List<SpatialLayer> backLayers;

  /// Physical perspective and dynamics configuration.
  final SpatialConfig config;

  /// External controller to drive or inspect flip progress and tilt.
  final SpatialController? controller;

  /// Width of the card.
  final double? width;

  /// Height of the card.
  final double? height;

  /// Axis along which the card flips.
  final FlipAxis flipAxis;

  /// Duration of the flip animation.
  final Duration flipDuration;

  /// Curve of the flip animation.
  final Curve flipCurve;

  /// Whether tapping the card triggers a 3D flip.
  final bool flipOnTap;

  /// Callback when flip starts or finishes.
  final ValueChanged<bool>? onFlipChanged;

  /// Corner radius override.
  final BorderRadius? borderRadius;

  /// Creates a [SpatialFlipCard].
  const SpatialFlipCard({
    super.key,
    this.frontMaterial = const SpatialMaterial(),
    this.backMaterial,
    this.frontLayers = const [],
    this.backLayers = const [],
    this.config = const SpatialConfig(),
    this.controller,
    this.width,
    this.height,
    this.flipAxis = FlipAxis.horizontal,
    this.flipDuration = const Duration(milliseconds: 700),
    this.flipCurve = Curves.easeOutBack,
    this.flipOnTap = true,
    this.onFlipChanged,
    this.borderRadius,
  });

  @override
  State<SpatialFlipCard> createState() => _SpatialFlipCardState();
}

class _SpatialFlipCardState extends State<SpatialFlipCard>
    with SingleTickerProviderStateMixin {
  late SpatialController _controller;
  bool _internalController = false;
  late AnimationController _flipAnimController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = SpatialController();
      _internalController = true;
    }

    _flipAnimController = AnimationController(
      vsync: this,
      duration: widget.flipDuration,
    );

    _flipAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _flipAnimController, curve: widget.flipCurve),
        )..addListener(() {
          _controller.setFlipProgress(_flipAnimation.value);
          setState(() {});
        });

    _controller.addListener(_onControllerFlipChanged);
  }

  void _onControllerFlipChanged() {
    if (_controller.isFlipped &&
        _flipAnimController.status != AnimationStatus.completed) {
      _flipAnimController.forward();
    } else if (!_controller.isFlipped &&
        _flipAnimController.status != AnimationStatus.dismissed) {
      _flipAnimController.reverse();
    }
  }

  void _toggleFlip() {
    if (_flipAnimController.isAnimating) return;

    if (widget.config.enableHaptics) {
      _controller.triggerHaptic();
    }

    if (_flipAnimController.isCompleted) {
      _flipAnimController.reverse().then((_) {
        widget.onFlipChanged?.call(false);
      });
    } else {
      _flipAnimController.forward().then((_) {
        widget.onFlipChanged?.call(true);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerFlipChanged);
    if (_internalController) {
      _controller.dispose();
    }
    _flipAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _flipAnimation.value;
    final isBack = progress >= 0.5;

    // Flip angle from 0 to pi
    final angle = progress * math.pi;

    return GestureDetector(
      onTap: widget.flipOnTap ? _toggleFlip : null,
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, widget.config.perspective)
          ..rotateY(widget.flipAxis == FlipAxis.horizontal ? angle : 0.0)
          ..rotateX(widget.flipAxis == FlipAxis.vertical ? angle : 0.0),
        child: isBack
            ? Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..rotateY(
                    widget.flipAxis == FlipAxis.horizontal ? math.pi : 0.0,
                  )
                  ..rotateX(
                    widget.flipAxis == FlipAxis.vertical ? math.pi : 0.0,
                  ),
                child: SpatialCard(
                  key: const ValueKey('back_face'),
                  material: widget.backMaterial ?? widget.frontMaterial,
                  config: widget.config,
                  controller: _controller,
                  layers: widget.backLayers,
                  width: widget.width,
                  height: widget.height,
                  borderRadius: widget.borderRadius,
                  onTap: widget.flipOnTap ? _toggleFlip : null,
                ),
              )
            : SpatialCard(
                key: const ValueKey('front_face'),
                material: widget.frontMaterial,
                config: widget.config,
                controller: _controller,
                layers: widget.frontLayers,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.borderRadius,
                onTap: widget.flipOnTap ? _toggleFlip : null,
              ),
      ),
    );
  }
}
