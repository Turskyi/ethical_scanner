part of 'home_presenter.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class LoadHomeEvent extends HomeEvent {
  const LoadHomeEvent();
}

class ShowProductInfoEvent extends HomeEvent {
  const ShowProductInfoEvent(this.productInfo);

  final ProductInfo productInfo;
}

class ClearProductInfoEvent extends HomeEvent {
  const ClearProductInfoEvent();
}

class NavigateToScanViewEvent extends HomeEvent {
  const NavigateToScanViewEvent();
}

class LaunchUrlEvent extends HomeEvent {
  const LaunchUrlEvent({required this.uri, required this.language});

  final String uri;
  final Language language;
}

class PrecipitationToggleEvent extends HomeEvent {
  const PrecipitationToggleEvent();
}

class SnapIngredientsEvent extends HomeEvent {
  const SnapIngredientsEvent();
}

class ChangeLanguageEvent extends HomeEvent {
  const ChangeLanguageEvent(this.language);
  final Language language;
}

final class BugReportPressedEvent extends HomeEvent {
  const BugReportPressedEvent();
}

final class SubmitFeedbackEvent extends HomeEvent {
  const SubmitFeedbackEvent(this.feedback);

  final UserFeedback feedback;
}

final class HomeErrorEvent extends HomeEvent {
  const HomeErrorEvent(this.error);

  final String error;
}
