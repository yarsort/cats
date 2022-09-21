
import 'package:json_annotation/json_annotation.dart';

part 'fact_response.g.dart';

@JsonSerializable()
class FactResponse {
  @JsonKey(name: 'fact')
  final String fact;

  @JsonKey(name: 'length')
  final int length;

  FactResponse(this.fact, this.length);

  factory FactResponse.fromJson(Map<String, dynamic> json) =>
      _$FactResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FactResponseToJson(this);
}