import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_cases/use_cases.dart';

import 'fake_product_info_gateway.dart';

void main() {
  group('LeaveRussiaResponse parsing', () {
    test('parses hit response correctly', () {
      final Map<String, Object?> json = <String, Object?>{
        'data': <Map<String, Object?>>[
          <String, Object?>{
            'name': 'Ferrero SpA',
            'company_name': 'Ferrero',
            'status': <String, Object?>{
              'key': 'stay',
              'en': 'Stay',
              'uk': 'Залишається',
            },
            'companypage': <String, Object?>{
              'en': 'https://leave-russia.org/ferrero',
              'uk': 'https://leave-russia.org/uk/ferrero',
            },
          },
        ],
      };

      final LeaveRussiaResponse response = LeaveRussiaResponse.fromJson(json);
      expect(response.data.length, equals(1));

      final LeaveRussiaItem? item = response.data.firstOrNull;
      expect(item?.displayName, equals('Ferrero'));
      expect(item?.status?.key, equals('stay'));
      expect(
        item?.companyPage?.getUrlForLanguage(Language.en),
        equals('https://leave-russia.org/ferrero'),
      );
      expect(
        item?.companyPage?.getUrlForLanguage(Language.uk),
        equals('https://leave-russia.org/uk/ferrero'),
      );
    });

    test('parses empty / miss response correctly', () {
      final Map<String, Object?> json = <String, Object?>{'data': <dynamic>[]};
      final LeaveRussiaResponse response = LeaveRussiaResponse.fromJson(json);
      expect(response.data, isEmpty);
      expect(response.firstItem, isNull);
    });

    test('parses raw string or invalid json as miss', () {
      final LeaveRussiaResponse response = LeaveRussiaResponse.fromJson(
        'Nothing was found',
      );
      expect(response.data, isEmpty);
      expect(response.firstItem, isNull);
    });
  });

  group('GetProductInfoUseCase with Leave Russia lookup', () {
    test(
      '062020023131 drops leading 0 and maps stay status to active sponsor red',
      () async {
        String? queriedBarcode;
        final FakeProductInfoGateway fakeGateway = FakeProductInfoGateway(
          offProduct: const ProductInfo(
            barcode: '062020023131',
            responseType: ProductResponseType.barcodeOnly,
          ),
          leaveRussiaResponse: const LeaveRussiaResponse(
            data: <LeaveRussiaItem>[
              LeaveRussiaItem(
                name: 'Ferrero SpA',
                companyName: 'Ferrero',
                status: LeaveRussiaStatus(key: 'stay'),
                companyPage: LeaveRussiaCompanyPage(
                  en: 'https://leave-russia.org/ferrero',
                ),
              ),
            ],
          ),
          onGetLeaveRussiaInfo: (String barcode, Language language) {
            queriedBarcode = barcode;
          },
        );

        final GetProductInfoUseCase useCase = GetProductInfoUseCase(
          fakeGateway,
        );
        final ProductInfo result = await useCase.call(
          const LocalizedCode(code: '062020023131', language: Language.en),
        );

        expect(queriedBarcode, equals('62020023131'));
        expect(result.brand, equals('Ferrero'));
        expect(result.isCompanyTerrorismSponsor, isTrue);
        expect(
          result.leaveRussiaUrl,
          equals('https://leave-russia.org/ferrero'),
        );
      },
    );

    test(
      'barcode starting with 46 does NOT call Leave Russia lookup',
      () async {
        int callCount = 0;
        final FakeProductInfoGateway fakeGateway = FakeProductInfoGateway(
          offProduct: const ProductInfo(barcode: '4601234567890'),
          onGetLeaveRussiaInfo: (String barcode, Language language) {
            callCount++;
          },
        );

        final GetProductInfoUseCase useCase = GetProductInfoUseCase(
          fakeGateway,
        );
        final ProductInfo result = await useCase.call(
          const LocalizedCode(code: '4601234567890', language: Language.en),
        );

        expect(callCount, equals(0));
        expect(result.isFromRussia, isTrue);
      },
    );

    test('exited or leave status is not marked red and allows OFF vegetarian '
        'to turn green', () async {
      final FakeProductInfoGateway fakeGateway = FakeProductInfoGateway(
        offProduct: const ProductInfo(
          barcode: '3017620422003',
          brand: 'Danone',
          vegetarian: Vegetarian.positive,
        ),
        leaveRussiaResponse: const LeaveRussiaResponse(
          data: <LeaveRussiaItem>[
            LeaveRussiaItem(
              name: 'Danone',
              companyName: 'Danone',
              status: LeaveRussiaStatus(key: 'exited'),
              companyPage: LeaveRussiaCompanyPage(
                en: 'https://leave-russia.org/danone',
              ),
            ),
          ],
        ),
      );

      final GetProductInfoUseCase useCase = GetProductInfoUseCase(fakeGateway);
      final ProductInfo result = await useCase.call(
        const LocalizedCode(code: '3017620422003', language: Language.en),
      );

      expect(result.isCompanyTerrorismSponsor, isFalse);
      expect(result.leaveRussiaUrl, equals('https://leave-russia.org/danone'));
      expect(result.isVegetarian, isTrue);
    });

    test(
      'failed request falls back to standard OFF and Yale list behavior',
      () async {
        final FakeProductInfoGateway fakeGateway = FakeProductInfoGateway(
          offProduct: const ProductInfo(
            barcode: '123456789',
            brand: 'SomeBrand',
          ),
          shouldThrowLeaveRussiaError: true,
        );

        final GetProductInfoUseCase useCase = GetProductInfoUseCase(
          fakeGateway,
        );
        final ProductInfo result = await useCase.call(
          const LocalizedCode(code: '123456789', language: Language.en),
        );

        expect(result.brand, equals('SomeBrand'));
        expect(result.isCompanyTerrorismSponsor, isFalse);
      },
    );
  });
}
