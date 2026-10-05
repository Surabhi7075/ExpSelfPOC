import 'package:flutter_test/flutter_test.dart';
import 'package:experience_centre_os/main.dart';

void main() {
  testWidgets('Experience Centre OS loads discovery screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ExperienceCentreOSApp());
    expect(find.text('Experience Centre OS'), findsOneWidget);
  });
}
