import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/page/homePage/bloc/mapCameraBloc/exportMapCameraBloc.dart';

class MapCameraBloc extends Bloc<MapCameraEvent, MapCameraState> {
  MapCameraBloc({required this.cameraRepo}) : super(InitState());
  final MapCameraRepo cameraRepo;

  @override
  Stream<MapCameraState> mapEventToState(MapCameraEvent event) async* {
    if (event is InitCameraEvent) {
      yield* initCameraEventHandle(event.lat!, event.lon!);
    }
  }

  Stream<MapCameraState> initCameraEventHandle(double lat, double lon) async* {
    await cameraRepo.setCameraPosition(lat, lon);
    //  아무런 의미 없는 state ~  그냥 update 하기 위해 만든 state~[InitDoneState]
    yield InitDoneState();
    yield InitSuccessState(cameraPosition: cameraRepo.cameraPosition!);
  }
}
