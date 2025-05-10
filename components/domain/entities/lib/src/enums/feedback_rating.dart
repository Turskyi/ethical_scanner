/// A user-provided sentiment rating.
enum FeedbackRating {
  bad,
  neutral,
  good;

  String get value {
    switch (this) {
      case FeedbackRating.bad:
        return 'Bad';
      case FeedbackRating.neutral:
        return 'Neutral';
      case FeedbackRating.good:
        return 'Good';
    }
  }
}
