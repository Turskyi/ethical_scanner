import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/router/routes.dart';
import 'package:interface_adapters/src/ui/res/values/country_documents.dart';
import 'package:interface_adapters/src/ui/res/values/sponsor_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal bottom sheet shown when the user taps the "Is country sponsor of
/// terrorism?" tile. Displays bundled PDF documents and external web sources.
class TerrorismDocumentsBottomSheet extends StatelessWidget {
  const TerrorismDocumentsBottomSheet({required this.documents, super.key});

  final CountryDocuments documents;

  static Future<void> show(
    BuildContext context, {
    required CountryDocuments documents,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext _) =>
          TerrorismDocumentsBottomSheet(documents: documents),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Drag handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                translate('terrorism_sponsor.documents_title'),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Document cards
            ...documents.documents.map(
              (SponsorDocument doc) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: _DocumentCard(document: doc),
              ),
            ),

            // External sources
            if (documents.externalUrls.isNotEmpty) ...<Widget>[
              const Divider(height: 32, indent: 24, endIndent: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  translate('terrorism_sponsor.external_sources'),
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ...documents.externalUrls.map(
                (String url) => ListTile(
                  leading: const Icon(Icons.open_in_browser, size: 20),
                  title: Text(
                    url,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () => launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DocumentCard extends StatefulWidget {
  const _DocumentCard({required this.document});

  final SponsorDocument document;

  @override
  State<_DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<_DocumentCard> {
  bool _isSaving = false;
  final GlobalKey _saveButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    translate(widget.document.titleKey),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              translate(widget.document.descriptionKey),
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (!kIsWeb) ...<Widget>[
                  OutlinedButton.icon(
                    key: _saveButtonKey,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_alt, size: 18),
                    label: Text(translate('terrorism_sponsor.save')),
                    onPressed: _isSaving ? null : _saveDocument,
                  ),
                  const SizedBox(width: 8),
                ],
                FilledButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(translate('terrorism_sponsor.open')),
                  onPressed: () => _openDocument(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDocument(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    nav.pop(); // dismiss the bottom sheet first
    nav.pushNamed(kPdfViewerPath, arguments: widget.document);
  }

  Future<void> _saveDocument() async {
    setState(() => _isSaving = true);
    try {
      final ByteData data = await rootBundle.load(widget.document.assetPath);
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/${widget.document.fileName}');
      await file.writeAsBytes(data.buffer.asUint8List());
      final RenderBox? box =
          _saveButtonKey.currentContext?.findRenderObject() as RenderBox?;
      final Rect sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : Rect.zero;
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path, mimeType: 'application/pdf')],
          subject: translate(widget.document.titleKey),
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
