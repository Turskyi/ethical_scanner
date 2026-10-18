import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_cases/use_cases.dart';

import 'fake_product_info_gateway.dart';

void main() {
  group('AiVegetarianCheckResponse tests', () {
    test('fromJson correctly parses valid JSON object', () {
      final Map<String, Object?> json = <String, Object?>{
        'isVegetarian': true,
        'confidence': 'high',
        'reason': 'All ingredients are plant-based.',
        'provider': 'Groq',
        'model': 'qwen/qwen3.8-27b',
      };

      final AiVegetarianCheckResponse response =
          AiVegetarianCheckResponse.fromJson(json);

      expect(response.isVegetarian, isTrue);
      expect(response.confidence, equals('high'));
      expect(response.reason, equals('All ingredients are plant-based.'));
      expect(response.provider, equals('Groq'));
      expect(response.model, equals('qwen/qwen3.8-27b'));
    });

    test('fromJson throws FormatException on invalid JSON', () {
      final Map<String, Object?> json = <String, Object?>{
        'isVegetarian': 'not_a_bool',
        'reason': 123,
      };

      expect(
        () => AiVegetarianCheckResponse.fromJson(json),
        throwsFormatException,
      );
    });
  });

  group('Vegetarian UseCases tests', () {
    late FakeProductInfoGateway fakeGateway;
    late CheckVegetarianUseCase checkVegetarianUseCase;
    late AddVegetarianLabelUseCase addVegetarianLabelUseCase;

    setUp(() {
      fakeGateway = const FakeProductInfoGateway();
      checkVegetarianUseCase = CheckVegetarianUseCase(fakeGateway);
      addVegetarianLabelUseCase = AddVegetarianLabelUseCase(fakeGateway);
    });

    test('CheckVegetarianUseCase returns response from gateway', () async {
      const CheckVegetarianParams params = CheckVegetarianParams(
        ingredients: 'Water, Sugar, Lemon Juice',
        barcode: '1234567890123',
        language: Language.en,
      );

      final AiVegetarianCheckResponse response = await checkVegetarianUseCase(
        params,
      );

      expect(response.isVegetarian, isTrue);
      expect(response.reason, equals('Fake reasoning'));
    });

    test('AddVegetarianLabelUseCase executes without error', () async {
      await expectLater(addVegetarianLabelUseCase('1234567890123'), completes);
    });
  });
}
