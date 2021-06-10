import 'package:parking/api/parkingApi.dart';

class PaginationReposytory {
  static final PaginationReposytory _paginationReposytory =
      PaginationReposytory._();
  static const int _pageSize = 20;
  ParkingApi parkingApi = ParkingApi();
  PaginationReposytory._();

  factory PaginationReposytory() {
    return _paginationReposytory;
  }

  Future<dynamic> getData({
    required int page,
  }) async {
    return parkingApi.data('', startRange: 1, endRange: 20);
  }
}
