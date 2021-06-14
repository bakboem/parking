// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getParkingInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetParkInfo _$GetParkInfoFromJson(Map<String, dynamic> json) {
  return GetParkInfo(
    dataList: (json['row'] as List<dynamic>?)
        ?.map((e) => ParkingData.fromJson(e as Map<String, dynamic>))
        .toList(),
    result: json['RESULT'] == null
        ? null
        : ParkingResult.fromJson(json['RESULT'] as Map<String, dynamic>),
    total: json['list_total_count'] as int?,
  );
}

Map<String, dynamic> _$GetParkInfoToJson(GetParkInfo instance) =>
    <String, dynamic>{
      'list_total_count': instance.total,
      'RESULT': instance.result,
      'row': instance.dataList,
    };
