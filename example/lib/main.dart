import 'package:flutter/material.dart';
import 'package:spatial_card/spatial_card.dart';

void main() {
  runApp(const SpatialCardDemoApp());
}

class SpatialCardDemoApp extends StatelessWidget {
  const SpatialCardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpatialCard Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF131C31),
        ),
      ),
      home: const SpatialCardShowcaseScreen(),
    );
  }
}

class SpatialCardShowcaseScreen extends StatefulWidget {
  const SpatialCardShowcaseScreen({super.key});

  @override
  State<SpatialCardShowcaseScreen> createState() =>
      _SpatialCardShowcaseScreenState();
}

class _SpatialCardShowcaseScreenState extends State<SpatialCardShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sandbox adjustable state
  double _depth = 24.0;
  double _specular = 1.0;
  double _tiltAngle = 0.35;
  bool _enableIdleDrift = true;
  bool _enableHaptics = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SpatialCard Engine',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: const Color(0xFF94A3B8),
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.credit_card), text: 'FinTech Presets'),
            Tab(icon: Icon(Icons.flip_to_back), text: '3D Flip Card'),
            Tab(icon: Icon(Icons.layers), text: 'Depth Stack'),
            Tab(icon: Icon(Icons.tune), text: 'Sandbox Controls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFintechTab(),
          _buildFlipCardTab(),
          _buildStackTab(),
          _buildSandboxTab(),
        ],
      ),
    );
  }

  Widget _buildFintechTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Tactile Material Surfaces',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Touch & drag to inspect physical specular highlights & multi-plane parallax.',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 1. Brushed Titanium FinTech Card
          SpatialCard(
            material: SpatialMaterial.brushedTitanium(),
            config: const SpatialConfig(parallaxIntensity: 24.0),
            layers: [
              SpatialLayer.base(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'TITANIUM ELITE',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SpatialLayer.floating(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: 44,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD4AF37), Color(0xFFA67C00)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0x66FFFFFF),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SpatialLayer.floating(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '5412 •••• •••• 9820',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              SpatialLayer.mid(
                alignment: Alignment.bottomLeft,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARDHOLDER',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'GOVIND TANK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 2. Holographic Collectible Pass
          SpatialCard(
            material: SpatialMaterial.holographicFoil(),
            config: const SpatialConfig(parallaxIntensity: 30.0),
            layers: [
              SpatialLayer.base(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'APEX COLLECTIBLE #001',
                    style: TextStyle(
                      color: Color(0xFFC084FC),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              SpatialLayer.floating(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x66A78BFA)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond_outlined,
                        color: Color(0xFF38BDF8),
                        size: 36,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'MYTHIC EDITION',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpatialLayer.mid(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x3338BDF8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x6638BDF8)),
                    ),
                    child: const Text(
                      'RANK 100',
                      style: TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 3. Frosted Obsidian Glass Pass
          SpatialCard(
            material: SpatialMaterial.frostedGlass(),
            config: const SpatialConfig(parallaxIntensity: 20.0),
            layers: [
              SpatialLayer.base(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'REVOLUT // OBSIDIAN',
                    style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SpatialLayer.floating(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL BALANCE',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$148,920.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFlipCardTab() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '3D Double-Sided Flip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap the card to smoothly flip 180° with continuous specular lighting.',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            SpatialFlipCard(
              frontMaterial: SpatialMaterial.cyberNeon(),
              backMaterial: SpatialMaterial.cyberNeon().copyWith(
                backgroundGradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF050811), Color(0xFF131C31)],
                ),
              ),
              frontLayers: [
                SpatialLayer.base(
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'NEON VIP // PASS',
                      style: TextStyle(
                        color: Color(0xFF00F0FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SpatialLayer.floating(
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Color(0xFFFF007A), size: 48),
                      SizedBox(height: 6),
                      Text(
                        'ACCESS GRANTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SpatialLayer.mid(
                  alignment: Alignment.bottomCenter,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'TAP TO REVEAL SECURITY QR',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
              backLayers: [
                SpatialLayer.base(
                  alignment: Alignment.topCenter,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'AUTHORIZATION CODE',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                SpatialLayer.floating(
                  alignment: Alignment.center,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      color: Colors.black,
                      size: 76,
                    ),
                  ),
                ),
                SpatialLayer.mid(
                  alignment: Alignment.bottomCenter,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'CVV: 891 • VALID THRU: 12/28',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackTab() {
    final stackColors = [
      SpatialMaterial.goldFoil(),
      SpatialMaterial.carbonFiber(),
      SpatialMaterial.holographicFoil(),
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '3D Depth Card Deck',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Swipe cards horizontally to cycle through the 3D elevation deck.',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            SpatialCardStack(
              layerOffset: 20.0,
              scaleStep: 0.05,
              children: List.generate(3, (index) {
                return SpatialCard(
                  key: ValueKey('deck_card_$index'),
                  material: stackColors[index],
                  layers: [
                    SpatialLayer.floating(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'TIER ${index + 1} ASSET',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Swipe to cycle',
                            style: TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSandboxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Live Dynamic Sandbox',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          SpatialCard(
            material: SpatialMaterial.holographicFoil(
              specularIntensity: _specular,
            ),
            config: SpatialConfig(
              parallaxIntensity: _depth,
              maxTiltAngle: _tiltAngle,
              enableIdleDrift: _enableIdleDrift,
              enableHaptics: _enableHaptics,
            ),
            layers: [
              SpatialLayer.floating(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.settings_suggest,
                      color: Color(0xFF38BDF8),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DEPTH: ${_depth.toInt()}px',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF131C31),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x22FFFFFF)),
            ),
            child: Column(
              children: [
                _buildSliderRow(
                  label: 'Parallax Depth Elevation',
                  value: _depth,
                  min: 0,
                  max: 50,
                  unit: 'px',
                  onChanged: (v) => setState(() => _depth = v),
                ),
                const Divider(color: Color(0x1AFFFFFF)),
                _buildSliderRow(
                  label: 'Specular Glare Intensity',
                  value: _specular,
                  min: 0.0,
                  max: 2.0,
                  unit: 'x',
                  onChanged: (v) => setState(() => _specular = v),
                ),
                const Divider(color: Color(0x1AFFFFFF)),
                _buildSliderRow(
                  label: 'Max Tilt Responsiveness',
                  value: _tiltAngle,
                  min: 0.1,
                  max: 0.6,
                  unit: ' rad',
                  onChanged: (v) => setState(() => _tiltAngle = v),
                ),
                const Divider(color: Color(0x1AFFFFFF)),
                // ignore: deprecated_member_use
                SwitchListTile(
                  title: const Text(
                    'Ambient Idle Drift Pulse',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _enableIdleDrift,
                  // ignore: deprecated_member_use
                  activeColor: const Color(0xFF38BDF8),
                  onChanged: (v) => setState(() => _enableIdleDrift = v),
                ),
                // ignore: deprecated_member_use
                SwitchListTile(
                  title: const Text(
                    'Micro-Haptic Feedback',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _enableHaptics,
                  // ignore: deprecated_member_use
                  activeColor: const Color(0xFF38BDF8),
                  onChanged: (v) => setState(() => _enableHaptics = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: const Color(0xFF38BDF8),
          inactiveColor: const Color(0xFF1E293B),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
