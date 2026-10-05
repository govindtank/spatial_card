# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 - Initial Release

- Initial release of `spatial_card`, a high-performance Flutter package for 3D tactile interactive cards.
- **Multi-Plane Z-Parallax:** Render arbitrary Flutter widgets on distinct elevation depth planes (`SpatialLayer`) with dynamic drop shadows.
- **Physical Specular Lighting:** Interactive glare and fresnel reflections reactive to touch coordinates and pointer hover.
- **Holographic Chromatic Dispersion:** Prismatic diffractive foil gradients that refract light across the surface.
- **Built-in Material Presets:**
  - `SpatialMaterial.holographicFoil()` (Iridescent collectible & gaming card sheen).
  - `SpatialMaterial.brushedTitanium()` (Apple Card-style metallic micro-grooves).
  - `SpatialMaterial.frostedGlass()` (Obsidian glass neobank & dark UI card).
  - `SpatialMaterial.cyberNeon()` (Cyberpunk glowing rim card).
  - `SpatialMaterial.carbonFiber()` (Diagonal woven carbon-fiber texture).
  - `SpatialMaterial.goldFoil()` (Polished warm metallic gold leaf).
- **Interactive 3D Flip Card:** `SpatialFlipCard` with seamless 180° double-sided rotation and continuous lighting.
- **3D Card Stack:** `SpatialCardStack` with progressive depth scaling, defocus opacity, and swipe gestures.
- **Lightweight Decorator:** `SpatialContainer` for wrapping any arbitrary widget with 3D tilt and specular sheen.
- **Tactile Dynamics:** Spring snap-back damping, press-down depth depression, micro-haptics, and ambient idle drift breathing loop.
- **100% Pure Flutter:** Zero heavy native ML models, zero native C++ build breakages, 120 FPS performance on Impeller and Skia across iOS, Android, Web, macOS, Windows, and Linux.
