import 'package:entities/entities.dart';

/// A data type holding user feedback consisting of a feedback type, free from
/// feedback text, and a sentiment rating.
class FeedbackDetails {
  const FeedbackDetails({
    this.feedbackType,
    this.feedbackText,
    this.rating,
  });

  final FeedbackType? feedbackType;
  final String? feedbackText;
  final FeedbackRating? rating;

  @override
  String toString() {
    return <String, String?>{
      if (rating != null) 'rating': rating.toString(),
      'feedback_type': feedbackType.toString(),
      'feedback_text': feedbackText,
    }.toString();
  }

  /// Creates a new [FeedbackDetails] instance with optional new values.
  ///
  /// If a parameter is not provided, the value from the original object is
  /// used.
  FeedbackDetails copyWith({
    FeedbackType? feedbackType,
    String? feedbackText,
    FeedbackRating? rating,
  }) {
    return FeedbackDetails(
      feedbackType: feedbackType ?? this.feedbackType,
      feedbackText: feedbackText ?? this.feedbackText,
      rating: rating ?? this.rating,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      if (rating != null) 'rating': rating,
      'feedback_type': feedbackType,
      'feedback_text': feedbackText,
    };
  }
}
