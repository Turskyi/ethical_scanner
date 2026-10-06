import 'package:json_annotation/json_annotation.dart';

part 'ai_barcode_info_response.g.dart';

@JsonSerializable()
class AiBarcodeInfoResponse {
  const AiBarcodeInfoResponse({required this.info, required this.provider});

  factory AiBarcodeInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$AiBarcodeInfoResponseFromJson(json);

  final String info;
  final String provider;

  Map<String, dynamic> toJson() => _$AiBarcodeInfoResponseToJson(this);
}
