import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapCameraState extends Equatable {
  const MapCameraState();
}

class InitSuccessState extends MapCameraState {
  const InitSuccessState({required this.cameraPosition});
  final CameraPosition cameraPosition;

  @override
  List<Object?> get props => [];
}

class InitDoneState extends MapCameraState {
  const InitDoneState();

  @override
  List<Object?> get props => [];
}

class InitState extends MapCameraState {
  const InitState();

  @override
  List<Object?> get props => [];
}
