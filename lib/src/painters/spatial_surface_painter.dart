import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/spatial_material.dart';

/// High-performance Canvas painter rendering physical material textures,
/// dynamic specular highlights, chromatic dispersion, and border bevels.
class SpatialSurfacePainter extends CustomPainter {
  /// The material configuration.
  final SpatialMaterial material;

  /// Current normalized horizontal tilt / light position in range `[-1.0, 1.0]`.
  final double tiltX;

  /// Current normalized vertical tilt / light position in range `[-1.0, 1.0]`.
  final double tiltY;

  /// Corner radius of the card surface.
  final BorderRadius borderRadius;

  /// Creates a [SpatialSurfacePainter].
  const SpatialSurfacePainter({
    required this.material,
    required this.tiltX,
    required this.tiltY,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    // Clip to rounded rectangle
    canvas.save();
    canvas.clipRRect(rrect);

    // 1. Draw Base Surface Gradient
    final basePaint = Paint()
      ..shader = material.backgroundGradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, basePaint);

    // 2. Draw Surface Micro-Texture Pattern
    _paintSurfacePattern(canvas, size, rect);

    // 3. Draw Holographic Chromatic Dispersion (if enabled)
    if (material.chromaticDispersion > 0.0) {
      _paintChromaticDispersion(canvas, size, rect);
    }

    // 4. Draw Dynamic Specular Glare
    if (material.specularIntensity > 0.0) {
      _paintSpecularGlare(canvas, size, rect);
    }

    // 5. Draw Inner Ambient Bevel Highlight
    _paintInnerBevel(canvas, rrect);

    canvas.restore();

    // 6. Draw Outer Border Highlight
    _paintOuterBorder(canvas, rrect);
  }

  void _paintSurfacePattern(Canvas canvas, Size size, Rect rect) {
    switch (material.pattern) {
      case SurfacePattern.smooth:
        break;

      case SurfacePattern.brushedMetal:
        final brushPaint = Paint()
          ..color = const Color(0x08FFFFFF)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        for (double x = 0; x < size.width; x += 4.0) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), brushPaint);
        }
        break;

      case SurfacePattern.carbonFiber:
        final fiberPaint1 = Paint()
          ..color = const Color(0x14FFFFFF)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        final fiberPaint2 = Paint()
          ..color = const Color(0x1A000000)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        for (double d = -size.height; d < size.width + size.height; d += 8.0) {
          canvas.drawLine(
              Offset(d, 0), Offset(d + size.height, size.height), fiberPaint1);
          canvas.drawLine(Offset(d + 4, 0),
              Offset(d + 4 + size.height, size.height), fiberPaint2);
        }
        break;

      case SurfacePattern.cyberGrid:
        final gridPaint = Paint()
          ..color = material.borderColor.withValues(alpha: 0.12)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
        for (double x = 0; x < size.width; x += 24.0) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
        }
        for (double y = 0; y < size.height; y += 24.0) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        }
        break;

      case SurfacePattern.holographic:
        final holoStripePaint = Paint()
          ..color = const Color(0x0DFFFFFF)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        for (double d = -size.height; d < size.width + size.height; d += 6.0) {
          canvas.drawLine(Offset(d, 0),
              Offset(d + size.height * 0.7, size.height), holoStripePaint);
        }
        break;

      case SurfacePattern.frostedGlass:
        final noisePaint = Paint()
          ..color = const Color(0x06FFFFFF)
          ..style = PaintingStyle.fill;
        for (double x = 0; x < size.width; x += 8.0) {
          for (double y = 0; y < size.height; y += 8.0) {
            if (((x + y).toInt() % 16) == 0) {
              canvas.drawCircle(Offset(x, y), 1.2, noisePaint);
            }
          }
        }
        break;

      case SurfacePattern.goldFoil:
        final goldFleckPaint = Paint()
          ..color = const Color(0x1EFFF8E1)
          ..style = PaintingStyle.fill;
        for (double x = 4; x < size.width; x += 16.0) {
          for (double y = 4; y < size.height; y += 16.0) {
            canvas.drawRect(Rect.fromLTWH(x, y, 2.0, 2.0), goldFleckPaint);
          }
        }
        break;
    }
  }

  void _paintChromaticDispersion(Canvas canvas, Size size, Rect rect) {
    final lightX = ((tiltX + 1.0) / 2.0) * size.width;
    final lightY = ((tiltY + 1.0) / 2.0) * size.height;

    final angle = material.sheenAngle + (tiltX * 0.4);
    final diagonalDist =
        math.sqrt(size.width * size.width + size.height * size.height);

    final p1 = Offset(
      lightX - math.cos(angle) * diagonalDist * 0.5,
      lightY - math.sin(angle) * diagonalDist * 0.5,
    );
    final p2 = Offset(
      lightX + math.cos(angle) * diagonalDist * 0.5,
      lightY + math.sin(angle) * diagonalDist * 0.5,
    );

    final dispersionAlpha =
        (material.chromaticDispersion * 0.45).clamp(0.0, 1.0);

    final rainbowGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0x00FF007A),
        Color(0xFFFF007A).withValues(alpha: dispersionAlpha * 0.6),
        Color(0xFF00F0FF).withValues(alpha: dispersionAlpha * 0.8),
        Color(0xFFFFEE58).withValues(alpha: dispersionAlpha * 0.7),
        Color(0xFF00E676).withValues(alpha: dispersionAlpha * 0.6),
        const Color(0x0000E676),
      ],
      stops: const [0.0, 0.25, 0.45, 0.60, 0.75, 1.0],
    );

    final holoPaint = Paint()
      ..shader = rainbowGradient.createShader(Rect.fromPoints(p1, p2))
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, holoPaint);
  }

  void _paintSpecularGlare(Canvas canvas, Size size, Rect rect) {
    // Map normalized tilt [-1, 1] to focal light position on the card
    final lightX = ((tiltX + 1.0) / 2.0) * size.width;
    final lightY = ((tiltY + 1.0) / 2.0) * size.height;
    final focalPoint = Offset(lightX, lightY);

    final glareOpacity = (material.specularIntensity * 0.4).clamp(0.0, 0.95);

    final glareGradient = RadialGradient(
      center: Alignment(
        (focalPoint.dx / size.width) * 2.0 - 1.0,
        (focalPoint.dy / size.height) * 2.0 - 1.0,
      ),
      radius: material.specularRadius,
      colors: [
        Colors.white.withValues(alpha: glareOpacity),
        Colors.white.withValues(alpha: glareOpacity * 0.35),
        const Color(0x00FFFFFF),
      ],
      stops: const [0.0, 0.4, 1.0],
    );

    final glarePaint = Paint()
      ..shader = glareGradient.createShader(rect)
      ..blendMode = BlendMode.overlay;

    canvas.drawRect(rect, glarePaint);
  }

  void _paintInnerBevel(Canvas canvas, RRect rrect) {
    final innerHighlightPaint = Paint()
      ..color = material.innerHighlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final deflatedRRect = rrect.deflate(1.0);
    canvas.drawRRect(deflatedRRect, innerHighlightPaint);
  }

  void _paintOuterBorder(Canvas canvas, RRect rrect) {
    if (material.borderWidth <= 0.0) {
      return;
    }

    // Shift border highlight based on light direction
    final borderGradient = LinearGradient(
      begin: Alignment(tiltX, tiltY),
      end: Alignment(-tiltX, -tiltY),
      colors: [
        material.borderColor.withValues(alpha: 0.9),
        material.borderColor.withValues(alpha: 0.25),
      ],
    );

    final borderPaint = Paint()
      ..shader = borderGradient.createShader(rrect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = material.borderWidth;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(SpatialSurfacePainter oldDelegate) {
    return oldDelegate.material != material ||
        oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.borderRadius != borderRadius;
  }
}
