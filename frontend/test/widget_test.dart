import 'package:flutter_test/flutter_test.dart';
import 'package:maternal_health_ai/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaternalHealthApp());
    expect(find.text('Maternal'), findsOneWidget);
    expect(find.text('Health AI'), findsOneWidget);
  });
}
