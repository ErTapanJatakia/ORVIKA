import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../domain/qr_image_decoder.dart';
import '../domain/qr_image_file_cleanup.dart';
import '../../../core/localization/orvika_localizations.dart';

class QrImageScannerScreen extends StatefulWidget {
  const QrImageScannerScreen({super.key});

  @override
  State<QrImageScannerScreen> createState() => _QrImageScannerScreenState();
}

class _QrImageScannerScreenState extends State<QrImageScannerScreen> {
  static const int _maxImageBytes = 20 * 1024 * 1024;
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedFile;
  Uint8List? _imageBytes;
  String? _imagePath;
  String? _imageName;
  List<QrImageCode> _codes = const [];
  bool _loading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _retrieveLostImage();
  }

  Future<void> _retrieveLostImage() async {
    try {
      final response = await _picker.retrieveLostData();
      if (!mounted) return;
      final files = response.files;
      if (files != null && files.isNotEmpty) {
        await _loadSelectedImage(files.first);
      } else if (response.exception != null) {
        setState(() {
          _message = OrvikaLocalizations.of(context).text(
            'checker.image.error.selection',
            'The image could not be selected. Check the file and try again.',
          );
        });
      }
    } catch (_) {
      // Recovery is best-effort; the manual picker remains available.
    }
  }

  Future<void> _cleanupSelectedFile() async {
    final previous = _selectedFile;
    _selectedFile = null;
    if (previous == null || kIsWeb) return;
    await deleteTemporaryQrImage(previous.path);
  }

  Future<void> _loadSelectedImage(XFile selected) async {
    final l10n = OrvikaLocalizations.of(context);
    try {
      final length = await selected.length();
      if (length <= 0) {
        if (!kIsWeb) await deleteTemporaryQrImage(selected.path);
        if (!mounted) return;
        setState(() {
          _message = l10n.text('checker.image.error.empty', 'The selected image is empty or could not be read.');
          _loading = false;
        });
        return;
      }
      if (length > _maxImageBytes) {
        if (!kIsWeb) await deleteTemporaryQrImage(selected.path);
        if (!mounted) return;
        setState(() {
          _message = l10n.text('checker.image.error.tooLarge', 'Please choose an image smaller than 20 MB.');
          _loading = false;
        });
        return;
      }

      final bytes = await selected.readAsBytes();
      if (!mounted) {
        if (!kIsWeb) await deleteTemporaryQrImage(selected.path);
        return;
      }
      await _cleanupSelectedFile();
      setState(() {
        _selectedFile = selected;
        _imageBytes = bytes;
        _imagePath = selected.path;
        _imageName = selected.name;
        _loading = false;
      });
    } catch (_) {
      if (!kIsWeb) await deleteTemporaryQrImage(selected.path);
      if (!mounted) return;
      setState(() {
        _message = l10n.text('checker.image.error.selection', 'The image could not be selected. Check the file and try again.');
        _loading = false;
      });
    }
  }

  Future<void> _chooseImage() async {
    setState(() {
      _loading = true;
      _message = null;
      _codes = const [];
    });
    try {
      final selected = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (!mounted) {
        if (selected != null && !kIsWeb) {
          await deleteTemporaryQrImage(selected.path);
        }
        return;
      }
      if (selected == null) {
        setState(() => _loading = false);
        return;
      }
      await _loadSelectedImage(selected);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message = OrvikaLocalizations.of(context).text(
          'checker.image.error.selection',
          'The image could not be selected. Check the file and try again.',
        );
        _loading = false;
      });
    }
  }

  Future<void> _decodeImage() async {
    final l10n = OrvikaLocalizations.of(context);
    final bytes = _imageBytes;
    final path = _imagePath;
    if (bytes == null || path == null || _loading) return;

    setState(() {
      _loading = true;
      _message = null;
      _codes = const [];
    });
    try {
      final results = await decodeQrImage(
        bytes: bytes,
        path: kIsWeb ? (_imageName ?? path) : path,
      );
      if (!mounted) return;
      setState(() {
        _codes = results;
        _message = results.isEmpty
            ? l10n.text('checker.image.error.noCode', 'No supported QR code or barcode was detected. Try a clearer image with the code fully visible.')
            : null;
        _loading = false;
      });
    } on UnsupportedError catch (error) {
      if (!mounted) return;
      setState(() {
        _message = error.message;
        _loading = false;
      });
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _message = error.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message = l10n.text('checker.image.error.decode', 'This image could not be decoded on this device or browser.');
        _loading = false;
      });
    }
  }

  Future<void> _clearImage() async {
    await _cleanupSelectedFile();
    if (!mounted) return;
    setState(() {
      _imageBytes = null;
      _imagePath = null;
      _imageName = null;
      _codes = const [];
      _message = null;
    });
  }

  @override
  void dispose() {
    _imageBytes = null;
    final selected = _selectedFile;
    _selectedFile = null;
    if (selected != null && !kIsWeb) {
      unawaited(deleteTemporaryQrImage(selected.path));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = OrvikaLocalizations.of(context);
    final bytes = _imageBytes;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.text('checker.image.title', 'Scan from image')),
        leading: IconButton(
          tooltip: l10n.text('checker.image.close', 'Close image scanner'),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              l10n.text('checker.image.instruction', 'Choose an image containing a QR code or barcode.'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              'ORVIKA accesses only the image you select for this scan. Selected image bytes are analysed on this device and cleared when you leave this screen. The operating system or browser may temporarily cache the selected file.',
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _loading ? null : _chooseImage,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(bytes == null
                  ? l10n.text('checker.image.choose', 'Choose image')
                  : l10n.text('checker.image.chooseAnother', 'Choose another image')),
            ),
            if (bytes != null) ...[
              const SizedBox(height: 14),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l10n.text('checker.image.previewUnavailable', 'Preview unavailable for this image format.')),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _imageName ?? l10n.text('checker.image.selected', 'Selected image'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: _loading ? null : _decodeImage,
                icon: const Icon(Icons.document_scanner_outlined),
                label: Text(_loading
                    ? l10n.text('checker.image.scanning', 'Scanning image…')
                    : l10n.text('checker.image.detect', 'Detect codes in image')),
              ),
              TextButton.icon(
                onPressed: _loading ? null : _clearImage,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.text('checker.image.clear', 'Clear selected image')),
              ),
            ],
            if (_loading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_message != null) ...[
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Text(
                  _message!,
                  style: TextStyle(color: scheme.error, height: 1.4),
                ),
              ),
            ],
            if (_codes.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                l10n.textWithParameters(
                  _codes.length == 1 ? 'checker.image.detectedOne' : 'checker.image.detectedMany',
                  fallback: _codes.length == 1 ? 'Detected {count} code' : 'Detected {count} codes',
                  parameters: {'count': _codes.length},
                ),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              for (var index = 0; index < _codes.length; index++)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.qr_code_2_outlined),
                    title: Text(_codes[index].format.toUpperCase()),
                    subtitle: Text(
                      _codes[index].value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pop(_codes[index]),
                  ),
                ),
              Text(
                l10n.text('checker.image.selectResult', 'Select a result to inspect its decoded content. Nothing is opened or executed automatically.'),
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
