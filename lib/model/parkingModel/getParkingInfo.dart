import 'package:json_annotation/json_annotation.dart';
import 'parkingData.dart';
import 'parkingResult.dart';
part 'getParkingInfo.g.dart';

@JsonSerializable()
class GetParkInfo {
  @JsonKey(name: 'list_total_count')
  int? total;
  @JsonKey(name: 'RESULT')
  ParkingResult? result;
  @JsonKey(name: 'row')
  List<ParkingData>? dataList;
  GetParkInfo({this.dataList, this.result, this.total});
  factory GetParkInfo.fromJson(Map<String, dynamic> json) =>
      _$GetParkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GetParkInfoToJson(this);
}
