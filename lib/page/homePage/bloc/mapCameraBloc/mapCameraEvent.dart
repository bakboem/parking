import 'package:equatable/equatable.dart';

abstract class MapCameraEvent extends Equatable {
  const MapCameraEvent();
}

class InitCameraEvent extends MapCameraEvent {
  const InitCameraEvent({required this.lat, required this.lon});
  final double? lat;
  final double? lon;

  @override
  List<Object?> get props => [];
}
