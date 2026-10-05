import 'package:flutter/material.dart';

/// A 3D stacked deck of spatial cards with progressive depth scaling,
/// defocus opacity, and swipeable elevation.
class SpatialCardStack extends StatefulWidget {
  /// The list of card widgets to display in the stack.
  final List<Widget> children;

  /// Vertical offset gap between each stacked card layer (in pixels).
  final double layerOffset;

  /// Scale reduction factor per stack depth level (e.g. `0.06` = 6% smaller per deeper card).
  final double scaleStep;

  /// Opacity reduction per stack depth level.
  final double opacityStep;

  /// Maximum number of cards visible simultaneously.
  final int maxVisibleCards;

  /// Callback when the top card is dismissed or swiped away.
  final ValueChanged<int>? onCardSwiped;

  /// Creates a [SpatialCardStack].
  const SpatialCardStack({
    super.key,
    required this.children,
    this.layerOffset = 18.0,
    this.scaleStep = 0.05,
    this.opacityStep = 0.15,
    this.maxVisibleCards = 3,
    this.onCardSwiped,
  });

  @override
  State<SpatialCardStack> createState() => _SpatialCardStackState();
}

class _SpatialCardStackState extends State<SpatialCardStack> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalCards = widget.children.length;
    final visibleCount = (totalCards - _currentIndex).clamp(
      0,
      widget.maxVisibleCards,
    );

    return Stack(
      alignment: Alignment.center,
      children: List.generate(visibleCount, (index) {
        // Reverse order so top card renders on top
        final reverseIndex = visibleCount - 1 - index;
        final cardIndex = _currentIndex + reverseIndex;
        if (cardIndex >= totalCards) return const SizedBox.shrink();

        final scale = 1.0 - (reverseIndex * widget.scaleStep);
        final offsetY = reverseIndex * widget.layerOffset;
        final opacity = (1.0 - (reverseIndex * widget.opacityStep)).clamp(
          0.0,
          1.0,
        );

        final isTop = reverseIndex == 0;

        return Transform.translate(
          offset: Offset(0.0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: opacity,
              child: isTop
                  ? Dismissible(
                      key: ValueKey('stack_card_$cardIndex'),
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) {
                        setState(() {
                          _currentIndex = (_currentIndex + 1) % totalCards;
                        });
                        widget.onCardSwiped?.call(cardIndex);
                      },
                      child: widget.children[cardIndex],
                    )
                  : widget.children[cardIndex],
            ),
          ),
        );
      }),
    );
  }
}
