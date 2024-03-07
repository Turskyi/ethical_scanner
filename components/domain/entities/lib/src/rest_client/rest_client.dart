import 'package:entities/src/terrorism_sponsor/terrorism_sponsor.dart';

abstract interface class RestClient {
  const RestClient();

  Future<List<TerrorismSponsor>> getTerrorismSponsors();

  Future<List<TerrorismSponsor>> getBackupTerrorismSponsors();
}
