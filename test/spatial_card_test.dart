import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spatial_card/spatial_card.dart';

void main() {
  group('SpatialMaterial Tests', () {
    test('Default constructor and presets instantiate properly', () {
      const defaultMat = SpatialMaterial();
      expect(defaultMat.specularIntensity, 0.8);
      expect(defaultMat.chromaticDispersion, 0.0);
      expect(defaultMat.pattern, SurfacePattern.smooth);

      final holo = SpatialMaterial.holographicFoil();
      expect(holo.chromaticDispersion, 0.85);
      expect(holo.pattern, SurfacePattern.holographic);

      final titanium = SpatialMaterial.brushedTitanium();
      expect(titanium.pattern, SurfacePattern.brushedMetal);

      final glass = SpatialMaterial.frostedGlass();
      expect(glass.pattern, SurfacePattern.frostedGlass);

      final cyber = SpatialMaterial.cyberNeon();
      expect(cyber.pattern, SurfacePattern.cyberGrid);

      final carbon = SpatialMaterial.carbonFiber();
      expect(carbon.pattern, SurfacePattern.carbonFiber);

      final gold = SpatialMaterial.goldFoil();
      expect(gold.pattern, SurfacePattern.goldFoil);
    });

    test('Material copyWith and equality work correctly', () {
      final base = SpatialMaterial.holographicFoil();
      final copy = base.copyWith(specularIntensity: 1.5);
      expect(copy.specularIntensity, 1.5);
      expect(copy.chromaticDispersion, base.chromaticDispersion);
      expect(copy == base, isFalse);

      final clone = base.copyWith();
      expect(clone == base, isTrue);
      expect(clone.hashCode, base.hashCode);
    });
  });

  group('SpatialConfig & SpatialLayer Tests', () {
    test('SpatialConfig presets and copyWith', () {
      const config = SpatialConfig();
      expect(config.maxTiltAngle, 0.35);
      expect(config.perspective, 0.0015);
      expect(config.enableHaptics, isTrue);

      final subtle = SpatialConfig.subtle();
      expect(subtle.maxTiltAngle, 0.20);

      final immersive = SpatialConfig.immersive();
      expect(immersive.maxTiltAngle, 0.45);

      final mod = config.copyWith(parallaxIntensity: 40.0);
      expect(mod.parallaxIntensity, 40.0);
      expect(mod == config, isFalse);
    });

    test('SpatialLayer factories and properties', () {
      const child = Text('Test Layer');
      final baseLayer = SpatialLayer.base(child: child);
      expect(baseLayer.depth, 0.0);
      expect(baseLayer.castShadow, isFalse);

      final midLayer = SpatialLayer.mid(child: child);
      expect(midLayer.depth, 0.5);
      expect(midLayer.castShadow, isTrue);

      final floatLayer = SpatialLayer.floating(child: child);
      expect(floatLayer.depth, 1.0);
      expect(floatLayer.castShadow, isTrue);
    });
  });

  group('SpatialController Tests', () {
    test('Controller handles tilt, press, and flip updates', () {
      final controller = SpatialController();
      expect(controller.tiltX, 0.0);
      expect(controller.tiltY, 0.0);
      expect(controller.isFlipped, isFalse);
      expect(controller.isPressed, isFalse);

      controller.setTilt(0.5, -0.5);
      expect(controller.tiltX, 0.5);
      expect(controller.tiltY, -0.5);

      // Clamp test
      controller.setTilt(1.8, -2.5);
      expect(controller.tiltX, 1.0);
      expect(controller.tiltY, -1.0);

      controller.setPressed(true);
      expect(controller.isPressed, isTrue);

      controller.toggleFlip();
      expect(controller.isFlipped, isTrue);

      controller.resetTilt();
      expect(controller.tiltX, 0.0);
      expect(controller.tiltY, 0.0);

      controller.dispose();
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('SpatialCard renders without errors and responds to gesture', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SpatialCard(
                width: 320,
                height: 200,
                material: SpatialMaterial.brushedTitanium(),
                config: const SpatialConfig(enableIdleDrift: false),
                layers: [
                  SpatialLayer.floating(child: const Text('Floating Content')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Floating Content'), findsOneWidget);

      // Simulate pan gesture
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(SpatialCard)),
      );
      await gesture.moveBy(const Offset(30, 20));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SpatialCard), findsOneWidget);
    });

    testWidgets('SpatialFlipCard renders and flips on tap', (tester) async {
      bool flipped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SpatialFlipCard(
                width: 300,
                height: 180,
                config: const SpatialConfig(enableIdleDrift: false),
                onFlipChanged: (val) => flipped = val,
                frontLayers: [
                  SpatialLayer.base(child: const Text('Front Content')),
                ],
                backLayers: [
                  SpatialLayer.base(child: const Text('Back Content')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Front Content'), findsOneWidget);

      // Tap to flip
      await tester.tap(find.byType(SpatialFlipCard));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      expect(flipped, isTrue);
      expect(find.text('Back Content'), findsOneWidget);
    });

    testWidgets('SpatialCardStack renders children and allows dismiss', (
      tester,
    ) async {
      int swipedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SpatialCardStack(
                onCardSwiped: (idx) => swipedIndex = idx,
                children: const [
                  Text('Card 0'),
                  Text('Card 1'),
                  Text('Card 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);

      // Swipe Card 0
      await tester.drag(find.text('Card 0'), const Offset(400, 0));
      await tester.pumpAndSettle();

      expect(swipedIndex, 0);
      expect(find.text('Card 1'), findsOneWidget);
    });

    testWidgets('SpatialContainer renders arbitrary wrapped child', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SpatialContainer(
                width: 140,
                height: 50,
                config: SpatialConfig(enableIdleDrift: false),
                child: Text('Click Me'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(SpatialContainer), findsOneWidget);
    });
  });
}
