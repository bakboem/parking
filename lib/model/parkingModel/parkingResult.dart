import 'package:json_annotation/json_annotation.dart';
part 'parkingResult.g.dart';

@JsonSerializable()
class ParkingResult {
  @JsonKey(name: 'CODE')
  String? code;
  @JsonKey(name: 'MESSAGE')
  String? message;
  ParkingResult({this.code, this.message});

  factory ParkingResult.fromJson(Map<String, dynamic> json) =>
      _$ParkingResultFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingResultToJson(this);
}
