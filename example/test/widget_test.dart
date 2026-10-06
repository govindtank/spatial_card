import 'package:flutter_test/flutter_test.dart';
import 'package:spatial_card_example/main.dart';

void main() {
  testWidgets('SpatialCardDemoApp mounts cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const SpatialCardDemoApp());
    expect(find.byType(SpatialCardDemoApp), findsOneWidget);
  });
}
