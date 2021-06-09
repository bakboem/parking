import 'package:json_annotation/json_annotation.dart';
import 'parkingData.dart';
import 'parkingResult.dart';
part 'getParkingInfo.g.dart';

@JsonSerializable()
class GetParkingInfo {
  @JsonKey(name: 'list_total_count')
  int? total;
  @JsonKey(name: 'RESULT')
  ParkingResult? result;
  @JsonKey(name: 'row')
  List<ParkingData>? dataList;
  GetParkingInfo({this.dataList, this.result, this.total});
  factory GetParkingInfo.fromJson(Map<String, dynamic> json) =>
      _$GetParkingInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GetParkingInfoToJson(this);
}
