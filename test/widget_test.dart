import 'package:flutter_test/flutter_test.dart';
import 'package:flutterweb/main.dart';

void main() {
  testWidgets('Cosmos Explorer loads', (WidgetTester tester) async {
    await tester.pumpWidget(const CosmosExplorerApp());
    expect(find.text('Cosmos Explorer'), findsOneWidget);
  });
}
