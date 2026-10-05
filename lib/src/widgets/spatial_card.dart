import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../controllers/spatial_controller.dart';
import '../models/spatial_config.dart';
import '../models/spatial_layer.dart';
import '../models/spatial_material.dart';
import '../painters/spatial_surface_painter.dart';

/// A 3D tactile interactive card widget featuring multi-plane depth parallax,
/// physical specular lighting, material shaders, and spring motion dynamics.
class SpatialCard extends StatefulWidget {
  /// Surface material definition (presets available: `SpatialMaterial.holographicFoil()`,
  /// `SpatialMaterial.brushedTitanium()`, `SpatialMaterial.frostedGlass()`, etc.).
  final SpatialMaterial material;

  /// Physical perspective and dynamics configuration.
  final SpatialConfig config;

  /// Optional external controller for programmatic tilt or flip control.
  final SpatialController? controller;

  /// Multi-elevation depth layers rendered on separate 3D Z-planes.
  final List<SpatialLayer> layers;

  /// Width of the card. If null, sizes to parent constraints.
  final double? width;

  /// Height of the card. If null, sizes to standard credit-card aspect ratio (1.586).
  final double? height;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the card is long pressed.
  final VoidCallback? onLongPress;

  /// Custom border radius override (defaults to `config.borderRadius`).
  final BorderRadius? borderRadius;

  /// Optional background widget behind the material shader (e.g. custom image or network photo).
  final Widget? background;

  /// Creates a [SpatialCard].
  const SpatialCard({
    super.key,
    this.material = const SpatialMaterial(),
    this.config = const SpatialConfig(),
    this.controller,
    this.layers = const [],
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.background,
  });

  @override
  State<SpatialCard> createState() => _SpatialCardState();
}

class _SpatialCardState extends State<SpatialCard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late SpatialController _controller;
  bool _internalController = false;

  late AnimationController _springController;
  late Animation<double> _springX;
  late Animation<double> _springY;

  late AnimationController _idleDriftController;
  double _lastHapticX = 0.0;
  double _lastHapticY = 0.0;

  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = SpatialController();
      _internalController = true;
    }
    _controller.addListener(_onControllerUpdate);

    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        _controller.setTilt(_springX.value, _springY.value);
      });

    _springX = const AlwaysStoppedAnimation(0.0);
    _springY = const AlwaysStoppedAnimation(0.0);

    _idleDriftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..addListener(_onIdleDrift);

    if (widget.config.enableIdleDrift &&
        widget.config.lightTracking != LightTrackingMode.touchOnly) {
      _idleDriftController.repeat();
    }
  }

  @override
  void didUpdateWidget(SpatialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_internalController) {
        _controller.removeListener(_onControllerUpdate);
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _internalController = false;
      } else {
        _controller = SpatialController();
        _internalController = true;
      }
      _controller.addListener(_onControllerUpdate);
    }

    if (widget.config.enableIdleDrift != oldWidget.config.enableIdleDrift) {
      if (widget.config.enableIdleDrift) {
        _idleDriftController.repeat();
      } else {
        _idleDriftController.stop();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_idleDriftController.isAnimating) {
        _idleDriftController.stop();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (widget.config.enableIdleDrift && !_isInteracting) {
        _idleDriftController.repeat();
      }
    }
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onIdleDrift() {
    if (_isInteracting) {
      return;
    }
    if (widget.config.lightTracking == LightTrackingMode.touchOnly ||
        widget.config.lightTracking == LightTrackingMode.fixed) {
      return;
    }

    final t = _idleDriftController.value * 2 * math.pi;
    final speed = widget.config.idleDriftSpeed;
    final driftX = math.sin(t * speed) * 0.45;
    final driftY = math.cos(t * 0.8 * speed) * 0.35;
    _controller.setTilt(driftX, driftY);
  }

  void _handlePointerMove(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) {
      return;
    }

    final normX = ((localPosition.dx / size.width) - 0.5) * 2.0;
    final normY = ((localPosition.dy / size.height) - 0.5) * 2.0;

    final clampedX = normX.clamp(-1.0, 1.0);
    final clampedY = normY.clamp(-1.0, 1.0);

    _controller.setTilt(clampedX, clampedY);
    _checkHapticThreshold(clampedX, clampedY);
  }

  void _checkHapticThreshold(double x, double y) {
    if (!widget.config.enableHaptics) {
      return;
    }

    final dist = math
        .sqrt(math.pow(x - _lastHapticX, 2) + math.pow(y - _lastHapticY, 2));
    if (dist >= 0.65) {
      _lastHapticX = x;
      _lastHapticY = y;
      _controller.triggerHaptic();
    }
  }

  void _startSpringReset() {
    _springX = Tween<double>(
      begin: _controller.tiltX,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.elasticOut,
    ));

    _springY = Tween<double>(
      begin: _controller.tiltY,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.elasticOut,
    ));

    _springController.forward(from: 0.0).then((_) {
      if (mounted && widget.config.enableIdleDrift && !_isInteracting) {
        _idleDriftController.repeat();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerUpdate);
    if (_internalController) {
      _controller.dispose();
    }
    _springController.dispose();
    _idleDriftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? widget.config.borderRadius;
    final tiltX = _controller.tiltX;
    final tiltY = _controller.tiltY;
    final isPressed = _controller.isPressed;

    // 3D Perspective Transformation Matrix
    final transform = Matrix4.identity()
      ..setEntry(3, 2, widget.config.perspective)
      ..rotateX(-tiltY * widget.config.maxTiltAngle)
      ..rotateY(tiltX * widget.config.maxTiltAngle)
      // ignore: deprecated_member_use
      ..scale(isPressed ? widget.config.pressScale : 1.0);

    // Dynamic Shadow Calculation (shifts opposite to tilt direction)
    final shadowOffsetX = -tiltX * 24.0;
    final shadowOffsetY = 16.0 - tiltY * 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = widget.width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : 340.0);
        final cardHeight = widget.height ?? (cardWidth / 1.586);

        return Center(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: MouseRegion(
              onEnter: (_) {
                _isInteracting = true;
                _springController.stop();
                _idleDriftController.stop();
              },
              onHover: (event) {
                if (!_isInteracting) {
                  _isInteracting = true;
                  _idleDriftController.stop();
                }
                _handlePointerMove(
                    event.localPosition, Size(cardWidth, cardHeight));
              },
              onExit: (_) {
                _isInteracting = false;
                _startSpringReset();
              },
              child: GestureDetector(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                onPanDown: (details) {
                  _isInteracting = true;
                  _springController.stop();
                  _idleDriftController.stop();
                  _controller.setPressed(true);
                  if (widget.config.enableHaptics) {
                    _controller.triggerHaptic();
                  }
                  _handlePointerMove(
                      details.localPosition, Size(cardWidth, cardHeight));
                },
                onPanUpdate: (details) {
                  _handlePointerMove(
                      details.localPosition, Size(cardWidth, cardHeight));
                },
                onPanEnd: (_) {
                  _isInteracting = false;
                  _controller.setPressed(false);
                  _startSpringReset();
                },
                onPanCancel: () {
                  _isInteracting = false;
                  _controller.setPressed(false);
                  _startSpringReset();
                },
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: transform,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: effectiveRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: widget.config.outerShadowOpacity,
                          ),
                          blurRadius: widget.config.outerShadowBlurRadius,
                          offset: Offset(shadowOffsetX, shadowOffsetY),
                          spreadRadius: isPressed ? -4.0 : 2.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: effectiveRadius,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 1. Optional background child (image/texture)
                          if (widget.background != null) widget.background!,

                          // 2. CustomPainter for Material Surface & Dynamic Specular Lighting
                          CustomPaint(
                            painter: SpatialSurfacePainter(
                              material: widget.material,
                              tiltX: tiltX,
                              tiltY: tiltY,
                              borderRadius: effectiveRadius,
                            ),
                          ),

                          // 3. Multi-depth Parallax Layer Stack
                          ...widget.layers.map((layer) {
                            final dx = tiltX *
                                widget.config.parallaxIntensity *
                                layer.depth *
                                layer.offsetMultiplier.dx;
                            final dy = -tiltY *
                                widget.config.parallaxIntensity *
                                layer.depth *
                                layer.offsetMultiplier.dy;

                            Widget layerContent = layer.child;

                            if (layer.castShadow && layer.depth > 0.1) {
                              final layerShadowDx = -tiltX * 8.0 * layer.depth;
                              final layerShadowDy =
                                  (tiltY * 8.0 + 4.0) * layer.depth;

                              layerContent = Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: layer.shadowColor,
                                      blurRadius:
                                          layer.shadowBlurRadius * layer.depth,
                                      offset:
                                          Offset(layerShadowDx, layerShadowDy),
                                    ),
                                  ],
                                ),
                                child: layer.child,
                              );
                            }

                            return Transform.translate(
                              offset: Offset(dx, dy),
                              child: layer.alignment != null
                                  ? Align(
                                      alignment: layer.alignment!,
                                      child: layerContent,
                                    )
                                  : layerContent,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
