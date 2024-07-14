import 'package:dio/dio.dart' hide Headers;
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/remote/models/russia_sponsors_response/russia_sponsor_response.dart';
import 'package:ethical_scanner/res/values/constants.dart' as constants;
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: constants.baseUrl)
abstract class RetrofitClient implements RestClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @override
  @GET('russia-sponsors')
  Future<List<RussiaSponsorResponse>> getTerrorismSponsors();
}
