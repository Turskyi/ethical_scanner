sealed class HomeEvent {
  const HomeEvent();
}

class ShowProductInfoEvent extends HomeEvent {
  const ShowProductInfoEvent(this.code);

  final String code;
}

class ClearProductInfoEvent extends HomeEvent {
  const ClearProductInfoEvent();
}

class NavigateToScanViewEvent extends HomeEvent {
  const NavigateToScanViewEvent();
}

class LaunchUrlEvent extends HomeEvent {
  const LaunchUrlEvent(this.uri);

  final String uri;
}

class ShowHomeEvent extends HomeEvent {
  const ShowHomeEvent();
}

class PrecipitationToggleEvent extends HomeEvent {
  const PrecipitationToggleEvent();
}
