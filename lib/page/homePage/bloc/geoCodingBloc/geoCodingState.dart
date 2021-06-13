abstract class GeoCodingState {
  const GeoCodingState();
}

class SuccessState extends GeoCodingState {
  SuccessState({required this.addr});
  String addr;
  get address => addr;
}

class ErrorState extends GeoCodingState {
  const ErrorState();
}

class InitState extends GeoCodingState {
  const InitState();
}
