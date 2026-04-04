import 'package:entities/entities.dart';
import 'package:interface_adapters/src/ui/res/values/sponsor_document.dart';

/// Maps a [ProductInfo] to the official documents and external source URLs
/// that recognize its country as a state sponsor of terrorism.
///
/// Add a new entry here when support for an additional country is needed.
class CountryDocuments {
  const CountryDocuments({required this.documents, required this.externalUrls});

  final List<SponsorDocument> documents;

  /// Web pages that supplement the bundled PDF documents.
  final List<String> externalUrls;

  bool get isEmpty => documents.isEmpty && externalUrls.isEmpty;

  // ── Russia ────────────────────────────────────────────────────────────────

  static const CountryDocuments _russia = CountryDocuments(
    documents: <SponsorDocument>[
      SponsorDocument(
        titleKey: 'terrorism_sponsor.eu_resolution_title',
        descriptionKey: 'terrorism_sponsor.eu_resolution_desc',
        assetPath: 'assets/documents/resolution_eu_2022.pdf',
        fileName: 'EU_Parliament_Resolution_2022.pdf',
      ),
      SponsorDocument(
        titleKey: 'terrorism_sponsor.nato_resolution_title',
        descriptionKey: 'terrorism_sponsor.nato_resolution_desc',
        assetPath: 'assets/documents/RESOLUTION_NATO_2022.pdf',
        fileName: 'NATO_Resolution_2022.pdf',
      ),
      SponsorDocument(
        titleKey: 'terrorism_sponsor.sejm_resolution_title',
        descriptionKey: 'terrorism_sponsor.sejm_resolution_desc',
        assetPath: 'assets/documents/sejm_resolution.pdf',
        fileName: 'Polish_Sejm_Resolution.pdf',
      ),
    ],
    externalUrls: <String>[
      'https://www.europarl.europa.eu/delegations/en/recognising-the-russian-federation-as-a-/product-details/20221124DPU34521',
    ],
  );

  // ── Factory ───────────────────────────────────────────────────────────────

  static CountryDocuments forProductInfo(ProductInfo info) {
    if (info.isFromRussia) {
      return _russia;
    }
    return const CountryDocuments(
      documents: <SponsorDocument>[],
      externalUrls: <String>[],
    );
  }
}
