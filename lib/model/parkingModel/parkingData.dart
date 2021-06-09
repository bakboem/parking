import 'package:json_annotation/json_annotation.dart';
part 'parkingData.g.dart';

@JsonSerializable()
class ParkingData {
  @JsonKey(name: 'PARKING_NAME')
  String? parkingName;
  @JsonKey(name: 'ADDR')
  String? addr;
  @JsonKey(name: 'PARKING_CODE')
  String? parkingCode;
  @JsonKey(name: 'PARKING_TYPE')
  String? parkingType;
  @JsonKey(name: 'PARKING_TYPE_NM')
  String? parkingTypeName;
  @JsonKey(name: 'OPERATION_RULE')
  String? operationRule;
  @JsonKey(name: 'OPERATION_RULE_NM')
  String? operationRuleName;
  @JsonKey(name: 'TEL')
  String? tel;
  @JsonKey(name: 'CAPACITY')
  double? capacity;
  @JsonKey(name: 'PAY_YN')
  String? payYn;
  @JsonKey(name: 'PAY_NM')
  String? payYnName;
  @JsonKey(name: 'NIGHT_FREE_OPEN')
  String? nightFreeOpen;
  @JsonKey(name: 'NIGHT_FREE_OPEN_NM')
  String? nightFreeOpenName;
  @JsonKey(name: 'WEEKDAY_BEGIN_TIME')
  String? weekDayBeginTime;
  @JsonKey(name: 'WEEKDAY_END_TIME')
  String? weekDayEndTime;
  @JsonKey(name: 'WEEKEND_BEGIN_TIME')
  String? weekEndBeginTime;
  @JsonKey(name: 'WEEKEND_END_TIME')
  String? weekEndEndTime;
  @JsonKey(name: 'HOLIDAY_BEGIN_TIME')
  String? holidayBeginTime;
  @JsonKey(name: 'HOLIDAY_END_TIME')
  String? holidayEndTime;
  @JsonKey(name: 'SYNC_TIME')
  String? syncTime;
  @JsonKey(name: 'SATURDAY_PAY_YN')
  String? saturDayPayYn;
  @JsonKey(name: 'SATURDAY_PAY_NM')
  String? saturDayPayName;
  @JsonKey(name: 'HOLIDAY_PAY_YN')
  String? holidayPayYn;
  @JsonKey(name: 'HOLIDAY_PAY_NM')
  String? holidayPayName;
  @JsonKey(name: 'FULLTIME_MONTHLY')
  String? fulltimeMonthly;
  @JsonKey(name: 'GRP_PARKNM')
  String? grpParkName;
  @JsonKey(name: 'RATES')
  double? ratest;
  @JsonKey(name: 'TIME_RATE')
  double? timeRate;
  @JsonKey(name: 'ADD_RATES')
  double? addRates;
  @JsonKey(name: 'ADD_TIME_RATE')
  double? addTimeRate;
  @JsonKey(name: 'BUS_RATES')
  double? busRates;
  @JsonKey(name: 'BUS_TIME_RATE')
  double? busTimeRate;
  @JsonKey(name: 'BUS_ADD_TIME_RATE')
  double? busAddTimeRate;
  @JsonKey(name: 'BUS_ADD_RATES')
  double? busAddRates;
  @JsonKey(name: 'DAY_MAXIMUM')
  double? dayMaximum;
  @JsonKey(name: 'LAT')
  double? lat;
  @JsonKey(name: 'LNG')
  double? lng;
  @JsonKey(name: 'ASSIGN_CODE')
  String? assignCode;
  @JsonKey(name: 'ASSIGN_CODE_NM')
  String? assignCodeName;

  ParkingData({
    this.addRates,
    this.addTimeRate,
    this.addr,
    this.assignCode,
    this.assignCodeName,
    this.busAddRates,
    this.busAddTimeRate,
    this.busRates,
    this.busTimeRate,
    this.capacity,
    this.dayMaximum,
    this.fulltimeMonthly,
    this.grpParkName,
    this.holidayBeginTime,
    this.holidayEndTime,
    this.holidayPayName,
    this.holidayPayYn,
    this.lat,
    this.lng,
    this.nightFreeOpen,
    this.nightFreeOpenName,
    this.operationRule,
    this.operationRuleName,
    this.parkingCode,
    this.parkingName,
    this.parkingType,
    this.parkingTypeName,
    this.payYn,
    this.payYnName,
    this.ratest,
    this.saturDayPayName,
    this.saturDayPayYn,
    this.syncTime,
    this.tel,
    this.timeRate,
    this.weekDayBeginTime,
    this.weekDayEndTime,
    this.weekEndBeginTime,
    this.weekEndEndTime,
  });
  factory ParkingData.fromJson(Map<String, dynamic> json) =>
      _$ParkingDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingDataToJson(this);
}
