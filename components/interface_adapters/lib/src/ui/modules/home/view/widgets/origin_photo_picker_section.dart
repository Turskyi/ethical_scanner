import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

class OriginPhotoPickerSection extends StatelessWidget {
  const OriginPhotoPickerSection({
    required this.onPickImage,
    required this.onRemovePhoto,
    this.photoPath,
    this.rotationTurns = 0,
    this.onRotatePhoto,
    super.key,
  });

  final String? photoPath;
  final int rotationTurns;
  final void Function(ImageSource source) onPickImage;
  final VoidCallback onRemovePhoto;
  final VoidCallback? onRotatePhoto;

  @override
  Widget build(BuildContext context) {
    final String? currentPhotoPath = photoPath;
    if (currentPhotoPath != null && currentPhotoPath.isNotEmpty) {
      final VoidCallback? rotateCallback = onRotatePhoto;
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RotatedBox(
                  quarterTurns: rotationTurns,
                  child: Image.file(
                    File(currentPhotoPath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            if (rotateCallback != null)
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  tooltip: translate('photo.rotate_photo'),
                  icon: const Icon(Icons.rotate_right, color: Colors.white),
                  onPressed: rotateCallback,
                ),
              ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.white),
                onPressed: onRemovePhoto,
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.photo_camera),
              label: Text(translate('product_info.take_photo')),
              onPressed: () => onPickImage(ImageSource.camera),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.photo_library),
              label: Text(translate('product_info.choose_gallery')),
              onPressed: () => onPickImage(ImageSource.gallery),
            ),
          ),
        ],
      );
    }
  }
}
