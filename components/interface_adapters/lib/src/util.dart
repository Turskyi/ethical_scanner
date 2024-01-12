import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Extract the downtime message from the HTML response
String extractDowntimeMessage(String exceptionSource) {
  final Document document = parse(exceptionSource);

  // Extract the text content within the <div class="main-content"> element
  final Element? mainContentElement = document.querySelector(
    'div.main-content',
  );
  if (mainContentElement != null) {
    final String message = mainContentElement.text.trim();
    return message;
  }

  return 'We are currently undergoing a major migration, and our services, '
      'including the Web platform, mobile app, API, and Producer Platform, '
      'are temporarily unavailable.';
}