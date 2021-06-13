import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';

class GeoCodingBloc extends Bloc<GeoCodingEvent, GeoCodingState> {
  GeoCodingBloc({required this.geoRepo}) : super(InitState());
  final GeoRepo geoRepo;
  @override
  Stream<GeoCodingState> mapEventToState(GeoCodingEvent event) async* {
    if (event is RequestAddrEvent) {
      yield* requestAddrEventHandle();
    }
  }

  Stream<GeoCodingState> requestAddrEventHandle() async* {
    var addr = await geoRepo.getAddr();
    print('211111');
    if (addr != null) {
      print('sbsbsb');
      print('sbsbsb');
      print('sbsbsb');
      print('sbsbsb');
      yield SuccessState(addr: addr);
    } else {
      yield ErrorState();
    }
  }
}
