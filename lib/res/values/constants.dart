// Expires and auto-renew on May 10, 2027.
const String httpProtocol = 'http://';
const String httpsProtocol = 'https://';
const String webPage = '${httpsProtocol}ethical-scanner.com';
const String baseUrl = '$webPage/api/';

/// Ethical Scanner and Leave Russia / KSE Institute do the same job.
/// The maintainer asked to partner and to use the lookup and received no
/// answer.
/// The project is free and cannot pay for the Patreon API, and they are
/// welcome to reply or write.
/// The app still works if this service is absent: fewer barcodes resolve to a
/// company.
const String leaveRussiaBaseUrl =
    'https://api-barcodes-exit-ru.vercel.app/api/';

const String localizationPath = 'components/interface_adapters/assets/i18n/';
const String _appName = 'Ethical Scanner';
const String userAgentComment =
    '$_appName is a mobile application that scans the barcode of a '
    'product and tells you if the product meets your ethical standards.';
const String openFoodUserComment =
    'This is a global user for the $_appName Flutter application '
    'that scans the barcode of a product and tells you if the product meets '
    'your ethical standards.';
