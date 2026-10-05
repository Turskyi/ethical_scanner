import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  if (kDebugMode) {
    test(
      'inspects actual property values of mobile_scanner Barcode objects',
      () {
        const String targetBarcode = '062020023131';

        // Native map payload for a UPC-A product barcode
        final Map<String, Object?> productNativeMap = <String, Object?>{
          'rawValue': targetBarcode,
          'displayValue': targetBarcode,
          'format': BarcodeFormat.upcA.rawValue,
          'type': BarcodeType.product.rawValue,
          'corners': <Map<String, double>>[
            <String, double>{'x': 10.0, 'y': 10.0},
            <String, double>{'x': 200.0, 'y': 10.0},
            <String, double>{'x': 200.0, 'y': 100.0},
            <String, double>{'x': 10.0, 'y': 100.0},
          ],
          'size': <String, double>{'width': 190.0, 'height': 90.0},
          'rawBytes': Uint8List.fromList(targetBarcode.codeUnits),
        };

        final Barcode productBarcode = Barcode.fromNative(productNativeMap);

        final LocalDataSourceImpl localDataSource = LocalDataSourceImpl();
        final String gs1Country = localDataSource.getGs1CountryFromBarcode(
          targetBarcode,
        );
        final String reportedOrigin = localDataSource
            .getReportedOriginFromBarcode(targetBarcode);

        debugPrint(
          '=== ACTUAL BARCODE OBJECT PROPERTIES '
          '(PRODUCT SCAN: $targetBarcode) ===',
        );
        debugPrint('barcode.rawValue: ${productBarcode.rawValue}');
        debugPrint('barcode.displayValue: ${productBarcode.displayValue}');
        debugPrint('barcode.format: ${productBarcode.format}');
        debugPrint('barcode.type: ${productBarcode.type}');
        debugPrint('barcode.corners: ${productBarcode.corners}');
        debugPrint('barcode.size: ${productBarcode.size}');
        debugPrint(
          'barcode.rawDecodedBytes: ${productBarcode.rawDecodedBytes}',
        );
        debugPrint('barcode.url: ${productBarcode.url}');
        debugPrint('barcode.contactInfo: ${productBarcode.contactInfo}');
        debugPrint('barcode.driverLicense: ${productBarcode.driverLicense}');
        debugPrint('barcode.email: ${productBarcode.email}');
        debugPrint('barcode.wifi: ${productBarcode.wifi}');
        debugPrint('barcode.phone: ${productBarcode.phone}');
        debugPrint('barcode.sms: ${productBarcode.sms}');
        debugPrint('barcode.geoPoint: ${productBarcode.geoPoint}');
        debugPrint('barcode.calendarEvent: ${productBarcode.calendarEvent}');
        debugPrint('GS1 Country (from Barcode Prefix): $gs1Country');
        if (reportedOrigin.isNotEmpty) {
          debugPrint('Reported Origin: $reportedOrigin');
        }

        // Demonstrate native map payloads for non-product barcodes
        debugPrint(
          '\n=== EXAMPLES OF TYPED BARCODE PAYLOAD OBJECTS (WHEN SCANNED) ===',
        );

        // URL Barcode
        final Barcode urlBarcode = Barcode.fromNative(<String, Object?>{
          'rawValue': 'https://world.openfoodfacts.org/product/$targetBarcode',
          'displayValue':
              'https://world.openfoodfacts.org/product/$targetBarcode',
          'format': BarcodeFormat.qrCode.rawValue,
          'type': BarcodeType.url.rawValue,
          'url': <String, String>{
            'title': 'OpenFoodFacts Product Page',
            'url': 'https://world.openfoodfacts.org/product/$targetBarcode',
          },
        });

        debugPrint('\n[URL Barcode]');
        debugPrint('barcode.type: ${urlBarcode.type}');
        debugPrint('barcode.url?.title: ${urlBarcode.url?.title}');
        debugPrint('barcode.url?.url: ${urlBarcode.url?.url}');

        // Contact Info Barcode
        final Barcode contactBarcode = Barcode.fromNative(<String, Object?>{
          'rawValue': 'MECARD:N:Fair Trade Corp;ORG:Fair Trade Foundation;;',
          'displayValue': 'Fair Trade Corp',
          'format': BarcodeFormat.qrCode.rawValue,
          'type': BarcodeType.contactInfo.rawValue,
          'contactInfo': <String, Object?>{
            'organization': 'Fair Trade Foundation',
            'title': 'Certified Supplier',
            'addresses': <Map<String, Object?>>[
              <String, Object?>{
                'addressLines': <String>['123 Ethical Way', 'Green City'],
              },
            ],
            'emails': <Map<String, Object?>>[
              <String, Object?>{'address': 'contact@fairtrade.org'},
            ],
          },
        });

        debugPrint('\n[Contact Info Barcode]');
        debugPrint('barcode.type: ${contactBarcode.type}');
        debugPrint(
          'barcode.contactInfo?.organization: '
          '${contactBarcode.contactInfo?.organization}',
        );
        debugPrint(
          'barcode.contactInfo?.title: ${contactBarcode.contactInfo?.title}',
        );
        debugPrint(
          'barcode.contactInfo?.addresses: '
          '${contactBarcode.contactInfo?.addresses}',
        );
        debugPrint(
          'barcode.contactInfo?.emails: ${contactBarcode.contactInfo?.emails}',
        );

        // Driver License Barcode
        final Barcode licenseBarcode = Barcode.fromNative(<String, Object?>{
          'rawValue': 'DL123456789',
          'displayValue': 'DL123456789',
          'format': BarcodeFormat.pdf417.rawValue,
          'type': BarcodeType.driverLicense.rawValue,
          'driverLicense': <String, String>{
            'firstName': 'Jane',
            'lastName': 'Doe',
            'licenseNumber': 'DL123456789',
            'issuingCountry': 'USA',
            'addressCity': 'Seattle',
            'addressState': 'WA',
          },
        });

        debugPrint('\n[Driver License Barcode]');
        debugPrint('barcode.type: ${licenseBarcode.type}');
        debugPrint(
          'barcode.driverLicense?.firstName: '
          '${licenseBarcode.driverLicense?.firstName}',
        );
        debugPrint(
          'barcode.driverLicense?.lastName: '
          '${licenseBarcode.driverLicense?.lastName}',
        );
        debugPrint(
          'barcode.driverLicense?.licenseNumber: '
          '${licenseBarcode.driverLicense?.licenseNumber}',
        );
        debugPrint(
          'barcode.driverLicense?.issuingCountry: '
          '${licenseBarcode.driverLicense?.issuingCountry}',
        );
        debugPrint(
          'barcode.driverLicense?.addressCity: '
          '${licenseBarcode.driverLicense?.addressCity}',
        );

        // WiFi Barcode
        final Barcode wifiBarcode = Barcode.fromNative(<String, Object?>{
          'rawValue': 'WIFI:S:EthicalStore_Guest;T:WPA;P:secret123;;',
          'displayValue': 'EthicalStore_Guest',
          'format': BarcodeFormat.qrCode.rawValue,
          'type': BarcodeType.wifi.rawValue,
          'wifi': <String, Object?>{
            'ssid': 'EthicalStore_Guest',
            'password': 'secret123',
            'encryptionType': 1,
          },
        });

        debugPrint('\n[WiFi Barcode]');
        debugPrint('barcode.type: ${wifiBarcode.type}');
        debugPrint('barcode.wifi?.ssid: ${wifiBarcode.wifi?.ssid}');
        debugPrint('barcode.wifi?.password: ${wifiBarcode.wifi?.password}');
        debugPrint(
          'barcode.wifi?.encryptionType: '
          '${wifiBarcode.wifi?.encryptionType}',
        );

        expect(productBarcode.rawValue, equals(targetBarcode));
        expect(urlBarcode.url?.url, contains(targetBarcode));
        expect(
          contactBarcode.contactInfo?.organization,
          equals('Fair Trade Foundation'),
        );
        expect(licenseBarcode.driverLicense?.issuingCountry, equals('USA'));
        expect(wifiBarcode.wifi?.ssid, equals('EthicalStore_Guest'));
      },
    );
  }
}
