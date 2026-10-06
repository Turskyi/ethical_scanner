import 'package:entities/src/rest_client/ai_barcode_info_response.dart';
import 'package:entities/src/rest_client/leave_russia_response.dart';
import 'package:entities/src/terrorism_sponsor/terrorism_sponsor.dart';

abstract interface class RestClient {
  const RestClient();

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  Future<AiBarcodeInfoResponse> getAiBarcodeInfo(Map<String, String> request);

  /// Queries the Leave Russia / KSE Institute barcode lookup API for company
  /// operational status in Russia for the given [barcode].
  ///
  /// Example hit response:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "name": "Ferrero SpA",
  ///       "company_name": "Ferrero",
  ///       "status": {
  ///         "key": "stay",
  ///         "en": "Stay",
  ///         "uk": "Залишається"
  ///       },
  ///       "companypage": {
  ///         "en": "https://leave-russia.org/ferrero",
  ///         "uk": "https://leave-russia.org/uk/ferrero"
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Example miss response:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  /// or `"Nothing was found"`.
  Future<LeaveRussiaResponse?> getLeaveRussiaInfo({required String barcode});
}
