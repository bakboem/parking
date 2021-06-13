import 'package:equatable/equatable.dart';

abstract class GeoCodingEvent extends Equatable {
  const GeoCodingEvent();
}

class RequestAddrEvent extends GeoCodingEvent {
  const RequestAddrEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}
