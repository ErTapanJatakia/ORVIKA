import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// A deliberately opt-in, one-result camera session.
///
/// The scanner never starts automatically. Camera capture is started only
/// after the user presses the explicit permission/start action. On a successful
/// decode the camera is stopped before the decoded value is returned.
class QrCameraScannerScreen extends StatefulWidget {
  const QrCameraScannerScreen({super.key});

  @override
  State<QrCameraScannerScreen> createState() => _QrCameraScannerScreenState();
}

class _QrCameraScannerScreenState extends State<QrCameraScannerScreen> {
  late final MobileScannerController _controller;
  bool _cameraActive = false;
  bool _starting = false;
  bool _handledCapture = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _startCamera() async {
    if (_starting || _cameraActive) return;
    setState(() {
      _starting = true;
      _statusMessage = null;
    });
    try {
      await _controller.start();
      if (!mounted) return;
      if (!_controller.value.hasCameraPermission) {
        setState(() {
          _statusMessage =
              'Camera permission was not granted. Check your browser or device settings, or continue by pasting decoded content.';
        });
      } else {
        setState(() => _cameraActive = true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusMessage =
            'Camera access is unavailable or was denied. Check that this page uses HTTPS, that a camera is connected, and that your browser or device permits camera access. You can still paste decoded content.';
      });
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<void> _stopCamera() async {
    await _controller.stop();
    if (mounted) setState(() => _cameraActive = false);
  }

  Future<void> _handleCapture(BarcodeCapture capture) async {
    if (_handledCapture) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null || value.trim().isEmpty) continue;
      _handledCapture = true;
      await _controller.stop();
      if (!mounted) return;
      Navigator.of(context).pop((
        value: value,
        format: barcode.format.name,
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan a code'),
        leading: IconButton(
          tooltip: 'Close scanner',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Camera access is requested only when you start scanning.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ORVIKA processes the decoded value on this device. It does not save camera frames or automatically open links, join networks, save contacts or make payments. Camera permission prompts and persistence are controlled by your browser or operating system.',
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _handleCapture,
                      placeholderBuilder: (context) => const Center(
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colors.white54, size: 56),
                      ),
                      errorBuilder: (context, error) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Camera preview could not start. ${error.errorCode.name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 250,
                          height: 190,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_statusMessage != null) ...[
                    Text(_statusMessage!,
                        style: TextStyle(color: scheme.error, height: 1.4)),
                    const SizedBox(height: 10),
                  ],
                  if (!_cameraActive)
                    FilledButton.icon(
                      onPressed: _starting ? null : _startCamera,
                      icon: const Icon(Icons.no_photography_outlined),
                      label: Text(_starting
                          ? 'Requesting camera access…'
                          : 'Allow camera for this scan'),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _stopCamera,
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('Stop camera'),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Supported formats depend on the camera, operating system and scanning backend. Unsupported devices can use the existing paste-and-check option.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 11, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
