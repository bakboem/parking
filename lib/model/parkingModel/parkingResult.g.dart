// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parkingResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingResult _$ParkingResultFromJson(Map<String, dynamic> json) {
  return ParkingResult(
    code: json['CODE'] as String?,
    message: json['MESSAGE'] as String?,
  );
}

Map<String, dynamic> _$ParkingResultToJson(ParkingResult instance) =>
    <String, dynamic>{
      'CODE': instance.code,
      'MESSAGE': instance.message,
    };
