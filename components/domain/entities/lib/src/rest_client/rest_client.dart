import 'package:entities/src/rest_client/ai_barcode_info_response.dart';
import 'package:entities/src/terrorism_sponsor/terrorism_sponsor.dart';

abstract interface class RestClient {
  const RestClient();

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  Future<AiBarcodeInfoResponse> getAiBarcodeInfo(Map<String, String> request);
}
