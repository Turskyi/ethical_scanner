import 'package:dio/dio.dart' hide Headers;
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/remote/models/russia_sponsors_response/russia_sponsor_response.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: 'https://api.standwithukraine.how/')
abstract class RetrofitClient implements RestClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @override
  @GET('/get-companies-database')
  Future<List<RussiaSponsorResponse>> getTerrorismSponsors();
}
