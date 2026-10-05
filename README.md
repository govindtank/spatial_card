# spatial_card

<p align="center">
  <a href="https://pub.dev/packages/spatial_card"><img src="https://img.shields.io/pub/v/spatial_card.svg?style=flat-square&color=blue" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/spatial_card/score"><img src="https://img.shields.io/pub/points/spatial_card?style=flat-square&color=2E8B57&label=pub%20points" alt="Pub Points"></a>
  <a href="https://pub.dev/packages/spatial_card"><img src="https://img.shields.io/pub/likes/spatial_card?style=flat-square" alt="Pub Likes"></a>
  <a href="https://github.com/govindtank/spatial_card/actions"><img src="https://github.com/govindtank/spatial_card/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=flat-square" alt="License"></a>
</p>

<p align="center">
  <b>A high-performance Flutter engine for 3D tactile interactive cards, multi-plane Z-parallax, dynamic specular lighting, and holographic chromatic foil shaders.</b>
</p>

<p align="center">
  <img src="./assets/spatial_card_demo.gif" width="600" alt="SpatialCard Interactive Demo" style="border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);" />
</p>

---

## ✨ Why `spatial_card`?

Most card widgets in Flutter are flat 2D boxes with static box shadows. Previous attempts at 3D depth often relied on heavy 30+ MB machine-learning models (like TFLite depth estimation) that suffer from native build failures, slow load times, and high memory usage.

`spatial_card` takes a **pure-Flutter, zero-native-dependency approach**:

- ⚡ **Ultra Lightweight (< 50 KB):** Zero heavy ML model weights or C++ dependencies.
- 🚀 **Silky 120 FPS Performance:** Fully hardware-accelerated via Impeller and Skia.
- 💎 **True Multi-Plane Z-Parallax:** Position any Flutter widget on distinct elevation planes (`SpatialLayer`) with dynamic drop shadows.
- 🌈 **Physical Specular & Chromatic Sheen:** Dynamic specular glare and prismatic rainbow dispersion that react fluidly to finger touches and cursor hover.
- 🔄 **3D Double-Sided Flip:** Flip between front and back faces with continuous 3D perspective (`SpatialFlipCard`).
- 📚 **3D Card Stack / Deck:** Depth-scaled swipeable card carousels (`SpatialCardStack`).
- 🌐 **100% Cross-Platform:** Flawless support for iOS, Android, Web, macOS, Windows, and Linux.

---

## 📸 Architecture & Visual Overview

<p align="center">
  <img src="./assets/screenshot.svg" width="100%" alt="SpatialCard Architecture Overview" />
</p>

---

## 📦 Installation

Add `spatial_card` to your `pubspec.yaml`:

```yaml
dependencies:
  spatial_card: ^1.0.0
```

Or install via terminal:

```bash
flutter pub add spatial_card
```

---

## 🚀 Quick Start

Wrap your widgets in `SpatialCard` and assign elements to separate elevation planes using `SpatialLayer`:

```dart
import 'package:flutter/material.dart';
import 'package:spatial_card/spatial_card.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1D),
      body: Center(
        child: SpatialCard(
          material: SpatialMaterial.holographicFoil(),
          config: const SpatialConfig(parallaxIntensity: 28.0),
          layers: [
            // Base layer (Z = 0)
            SpatialLayer.base(
              alignment: Alignment.topLeft,
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'APEX // COLLECTIBLE',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Floating high-depth layer (Z = 1.0)
            SpatialLayer.floating(
              alignment: Alignment.center,
              child: const Icon(Icons.diamond_outlined, color: Colors.cyanAccent, size: 56),
            ),
            // Mid layer (Z = 0.5)
            SpatialLayer.mid(
              alignment: Alignment.bottomLeft,
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'GOVIND TANK',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Built-In Material Presets

`spatial_card` includes six meticulously crafted material presets ready out of the box:

| Preset | Description |
| :--- | :--- |
| `SpatialMaterial.holographicFoil()` | Iridescent rainbow diffraction dispersion and vibrant specular glare. Ideal for collectibles, gaming cards, and VIP badges. |
| `SpatialMaterial.brushedTitanium()` | Subtle horizontal micro-grooves with focused metallic reflection (Apple Card / Revolut style). |
| `SpatialMaterial.frostedGlass()` | Translucent obsidian frosted glass with diffused ambient backlight. |
| `SpatialMaterial.cyberNeon()` | Deep cyberpunk navy with glowing cyan & magenta rim lighting. |
| `SpatialMaterial.goldFoil()` | Warm polished gold leaf flecks and warm metallic highlights. |
| `SpatialMaterial.carbonFiber()` | Diagonal woven carbon-fiber texture with anisotropic sheen. |

---

## 🔄 3D Double-Sided Flip Card

Easily create flip cards that rotate 180° in 3D space with continuous lighting:

```dart
SpatialFlipCard(
  frontMaterial: SpatialMaterial.cyberNeon(),
  backMaterial: SpatialMaterial.cyberNeon(),
  frontLayers: [
    SpatialLayer.floating(
      alignment: Alignment.center,
      child: const Text('TAP TO REVEAL QR', style: TextStyle(color: Colors.white)),
    ),
  ],
  backLayers: [
    SpatialLayer.floating(
      alignment: Alignment.center,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: const Icon(Icons.qr_code_2, size: 64, color: Colors.black),
      ),
    ),
  ],
)
```

---

## 📚 3D Card Stack / Deck

Create swipeable layered card stacks with progressive depth scaling and defocus blur:

```dart
SpatialCardStack(
  layerOffset: 18.0,
  scaleStep: 0.05,
  children: [
    SpatialCard(material: SpatialMaterial.goldFoil(), ...),
    SpatialCard(material: SpatialMaterial.carbonFiber(), ...),
    SpatialCard(material: SpatialMaterial.holographicFoil(), ...),
  ],
)
```

---

## 🎛️ Physical Dynamics & Customization

Fine-tune every aspect of the physics and perspective with `SpatialConfig`:

```dart
SpatialConfig(
  maxTiltAngle: 0.35,          // Max tilt in radians (~20 deg)
  perspective: 0.0015,         // Perspective factor (Z distortion)
  parallaxIntensity: 24.0,     // Parallax distance multiplier
  pressDepression: 0.06,       // Z-depth pushback on press
  pressScale: 0.98,            // Tactile scale squish
  springDamping: 0.75,         // Snap-back spring damping
  enableHaptics: true,         // Micro-haptics on interaction
  enableIdleDrift: true,       // Ambient figure-8 light breathing
  idleDriftSpeed: 1.0,         // Speed of ambient drift
)
```

---

## 📱 Running the Example

Clone the repository and run the demo application:

```bash
git clone https://github.com/govindtank/spatial_card.git
cd spatial_card/example
flutter run
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or pull request on [GitHub](https://github.com/govindtank/spatial_card).

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

*Crafted with 💙 by [Govind Tank](https://github.com/govindtank).*
