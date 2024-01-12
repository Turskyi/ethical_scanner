import 'package:entities/src/terrorism_sponsor/terrorism_sponsor.dart';

abstract class RestClient {
  const RestClient();

  Future<List<TerrorismSponsor>> getTerrorismSponsors();
}
