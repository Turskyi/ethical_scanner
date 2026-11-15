import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/modules/home/view/widgets/origin_photo_picker_section.dart';
import 'package:material_ui/material_ui.dart';

import '../ingredients_editor/fake_localization_delegate.dart';

void main() {
  late FakeLocalizationDelegate localizationDelegate;

  setUp(() {
    localizationDelegate = FakeLocalizationDelegate();
    Localization.load(<String, Object?>{
      'photo': <String, Object?>{'rotate_photo': 'Rotate photo'},
      'product_info': <String, Object?>{
        'take_photo': 'Take photo',
        'choose_gallery': 'Choose from gallery',
      },
    });
  });

  Widget buildTestWidget({required Widget child}) {
    return LocalizedApp(
      localizationDelegate,
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: Column(children: <Widget>[child])),
        ),
      ),
    );
  }

  testWidgets('renders photo picker buttons when photoPath is null', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: OriginPhotoPickerSection(
          onPickImage: (_) {},
          onRemovePhoto: () {},
        ),
      ),
    );

    expect(find.text('Take photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });

  testWidgets(
    'renders rotated photo section without layout errors for all quarter turns',
    (WidgetTester tester) async {
      for (int turns = 0; turns < 4; turns++) {
        await tester.pumpWidget(
          buildTestWidget(
            child: OriginPhotoPickerSection(
              photoPath: 'test_photo.jpg',
              rotationTurns: turns,
              onPickImage: (_) {},
              onRemovePhoto: () {},
              onRotatePhoto: () {},
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byIcon(Icons.rotate_right), findsOneWidget);
        expect(find.byIcon(Icons.cancel), findsOneWidget);
      }
    },
  );

  testWidgets('calls onRotatePhoto when rotate button is tapped', (
    WidgetTester tester,
  ) async {
    bool rotateCalled = false;
    await tester.pumpWidget(
      buildTestWidget(
        child: OriginPhotoPickerSection(
          photoPath: 'test_photo.jpg',
          rotationTurns: 1,
          onPickImage: (_) {},
          onRemovePhoto: () {},
          onRotatePhoto: () {
            rotateCalled = true;
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.rotate_right));
    expect(rotateCalled, isTrue);
  });
}
