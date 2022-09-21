// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactResponse _$FactResponseFromJson(Map<String, dynamic> json) => FactResponse(
      json['fact'] as String,
      json['length'] as int,
    );

Map<String, dynamic> _$FactResponseToJson(FactResponse instance) =>
    <String, dynamic>{
      'fact': instance.fact,
      'length': instance.length,
    };
