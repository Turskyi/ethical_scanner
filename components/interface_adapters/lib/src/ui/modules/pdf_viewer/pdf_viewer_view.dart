import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:interface_adapters/src/ui/res/resources.dart';
import 'package:interface_adapters/src/ui/res/values/sponsor_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerView extends StatefulWidget {
  const PdfViewerView({required this.document, super.key});

  final SponsorDocument document;

  @override
  State<PdfViewerView> createState() => _PdfViewerViewState();
}

class _PdfViewerViewState extends State<PdfViewerView> {
  Uint8List? _pdfBytes;
  bool _isSaving = false;
  final GlobalKey _downloadButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    final Resources resources = Resources.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: kIsWeb
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          translate(widget.document.titleKey),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: <Widget>[
          if (!kIsWeb)
            IconButton(
              key: _downloadButtonKey,
              tooltip: translate('terrorism_sponsor.save'),
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.download, color: Colors.white),
              onPressed: _isSaving ? null : _saveDocument,
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: resources.gradients.unauthorizedConstructionGradient,
        ),
        child: SafeArea(
          child: _pdfBytes == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : PDFView(
                  pdfData: _pdfBytes!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
        ),
      ),
    );
  }

  Future<void> _loadPdf() async {
    final ByteData data = await rootBundle.load(widget.document.assetPath);
    if (mounted) {
      setState(() {
        _pdfBytes = data.buffer.asUint8List();
      });
    }
  }

  Future<void> _saveDocument() async {
    setState(() => _isSaving = true);
    try {
      final ByteData data = await rootBundle.load(widget.document.assetPath);
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/${widget.document.fileName}');
      await file.writeAsBytes(data.buffer.asUint8List());
      final RenderBox? box =
          _downloadButtonKey.currentContext?.findRenderObject() as RenderBox?;
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
