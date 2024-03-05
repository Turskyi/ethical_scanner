import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Extract the downtime message from the HTML response
String extractErrorMessage(String exceptionSource) {
  final Document document = parse(exceptionSource);

  // Prioritize the main content element if it exists.
  final Element? mainContentElement =
      document.querySelector('div.main-content');
  if (mainContentElement != null) {
    final String message = mainContentElement.text.trim();
    return message;
  }

  // If the main content element is not found, extract from other potential
  // elements.
  final String message = _extractMessageFromAlternativeElements(document);
  return message.isNotEmpty ? message : _defaultErrorMessage();
}

String _extractMessageFromAlternativeElements(Document document) {
  final List<Element?> potentialElements = <Element?>[
    document.querySelector('h1'),
    document.querySelector('pre'),
    document.querySelector('p'),
  ];

  final StringBuffer messageBuffer = StringBuffer();
  for (Element? element in potentialElements) {
    if (element != null) {
      messageBuffer.write(element.text.trim());
      // Add a newline for better readability.
      messageBuffer.write('\n');
    }
  }

  return messageBuffer.toString().trim();
}

String _defaultErrorMessage() {
  return 'We are currently undergoing a major migration, and our services, '
      'including the Web platform, mobile app, API, and Producer Platform, '
      'are temporarily unavailable.';
}
