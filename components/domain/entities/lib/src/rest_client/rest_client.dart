import 'package:entities/src/rest_client/ai_barcode_info_request.dart';
import 'package:entities/src/rest_client/ai_barcode_info_response.dart';
import 'package:entities/src/rest_client/ai_vegetarian_check_request.dart';
import 'package:entities/src/rest_client/ai_vegetarian_check_response.dart';
import 'package:entities/src/rest_client/leave_russia_response.dart';
import 'package:entities/src/terrorism_sponsor/terrorism_sponsor.dart';

abstract interface class RestClient {
  const RestClient();

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  Future<AiBarcodeInfoResponse> getAiBarcodeInfo(AiBarcodeInfoRequest request);

  /// Sends a request to the backend AI endpoint to determine whether the
  /// product described by the provided ingredients is 100% vegetarian.
  ///
  /// Returns an [AiVegetarianCheckResponse] containing whether it is
  /// vegetarian, confidence level, reasoning, and AI model metadata.
  Future<AiVegetarianCheckResponse> checkVegetarianWithAi(
    AiVegetarianCheckRequest request,
  );

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
