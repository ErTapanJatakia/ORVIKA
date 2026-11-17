import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/localization/orvika_localizations.dart';

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

class _QrCameraScannerScreenState extends State<QrCameraScannerScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _cameraActive = false;
  bool _starting = false;
  bool _handledCapture = false;
  bool _cameraRequested = false;
  bool _pausedByLifecycle = false;
  String? _statusMessage;
  String? _reportedScannerError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _startCamera() async {
    final l10n = OrvikaLocalizations.of(context);
    if (_starting || _cameraActive || !_cameraRequested) return;
    _reportedScannerError = null;
    var restartAfterLifecycleStop = false;
    setState(() {
      _starting = true;
      _statusMessage = null;
    });
    try {
      await _controller.start();
      if (!mounted) return;
      // The app may have been backgrounded while start() was waiting for the
      // permission prompt or platform camera initialization. Do not leave the
      // camera active in that state; the resumed lifecycle path restarts it.
      if (_pausedByLifecycle ||
          WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        _pausedByLifecycle = true;
        try {
          await _controller.stop();
        } catch (_) {
          // Best-effort release after a lifecycle transition.
        }
        if (!mounted) return;
        if (!_controller.value.hasCameraPermission) {
          // Permission can be denied while the app is backgrounded by the
          // system prompt. Do not treat the subsequent resume as consent to
          // request camera access again.
          _cameraRequested = false;
          _pausedByLifecycle = false;
          setState(() {
            _cameraActive = false;
            _statusMessage =
                l10n.text('checker.camera.permissionDenied', 'Camera permission was not granted. Check your browser or device settings, or continue by pasting decoded content.');
          });
          return;
        }
        setState(() => _cameraActive = false);
        // If the app resumed while stop() was pending, the lifecycle callback
        // has already cleared _pausedByLifecycle but could not start because
        // this startup operation still owns the _starting guard.
        restartAfterLifecycleStop =
            _cameraRequested &&
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
        if (restartAfterLifecycleStop) _pausedByLifecycle = false;
        return;
      }
      if (!_controller.value.hasCameraPermission) {
        // A denied permission is not an ongoing request to use the camera.
        // Require another explicit tap before any later lifecycle resume can
        // attempt to request permission again.
        _cameraRequested = false;
        _pausedByLifecycle = false;
        setState(() {
          _statusMessage =
              l10n.text('checker.camera.permissionDenied', 'Camera permission was not granted. Check your browser or device settings, or continue by pasting decoded content.');
        });
      } else {
        setState(() => _cameraActive = true);
      }
    } catch (_) {
      if (!mounted) return;
      // A failed start must not silently re-request camera access on the next
      // background/foreground transition. The user can retry explicitly.
      _cameraRequested = false;
      _pausedByLifecycle = false;
      setState(() {
        _statusMessage =
            l10n.text('checker.camera.unavailable', 'Camera access is unavailable or was denied. Check that this page uses HTTPS, that a camera is connected, and that your browser or device permits camera access. You can still paste decoded content.');
      });
    } finally {
      if (mounted) {
        setState(() => _starting = false);
        // A resume event can arrive while start() is still awaiting the
        // platform permission/result. Its callback cannot start a second
        // session while _starting is true, so retry once startup has settled.
        if (restartAfterLifecycleStop &&
            _cameraRequested &&
            !_pausedByLifecycle &&
            !_cameraActive &&
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
          unawaited(_startCamera());
        }
      }
    }
  }

  void _announceScannerError(
    MobileScannerException error,
    OrvikaLocalizations l10n,
  ) {
    final message = l10n.textWithParameters(
      'checker.camera.previewError',
      fallback: 'Camera preview could not start. {error}',
      parameters: {'error': error.errorCode.name},
    );
    if (_reportedScannerError == message) return;
    _reportedScannerError = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _statusMessage = message);
    });
  }

  Future<void> _stopCamera() async {
    _cameraRequested = false;
    _pausedByLifecycle = false;
    try {
      await _controller.stop();
    } catch (_) {
      // The controller may already have stopped during a platform transition.
    }
    if (mounted) setState(() => _cameraActive = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // Do not stop while the initial permission prompt is unresolved. Once
        // capture is active, release the camera whenever the app is backgrounded.
        if (_cameraRequested && !_pausedByLifecycle && !_handledCapture) {
          _pausedByLifecycle = true;
          if (_cameraActive) {
            unawaited(_pauseCameraForLifecycle());
          }
          // If start() is still pending, _startCamera() will stop the camera
          // immediately after the platform call completes.
        }
        break;
      case AppLifecycleState.resumed:
        if (_cameraRequested && _pausedByLifecycle && !_handledCapture) {
          _pausedByLifecycle = false;
          unawaited(_startCamera());
        }
        break;
    }
  }

  Future<void> _pauseCameraForLifecycle() async {
    try {
      await _controller.stop();
    } catch (_) {
      // Best-effort release when the platform is already transitioning.
    }
    if (!mounted) return;
    setState(() => _cameraActive = false);

    // A quick foreground transition can arrive while stop() is still pending.
    // The resumed callback may try to restart while _cameraActive is still true;
    // retry only after the pending stop has completed.
    if (_cameraRequested &&
        !_pausedByLifecycle &&
        !_handledCapture &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      unawaited(_startCamera());
    }
  }

  Future<void> _handleCapture(BarcodeCapture capture) async {
    if (_handledCapture) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null || value.trim().isEmpty) continue;
      _handledCapture = true;
      _cameraRequested = false;
      _pausedByLifecycle = false;
      try {
        await _controller.stop();
      } catch (_) {
        // Continue returning the decoded value; disposal also releases resources.
      }
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
    final l10n = OrvikaLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.text('checker.camera.title', 'Scan a code')),
        leading: IconButton(
          tooltip: l10n.text('checker.camera.close', 'Close scanner'),
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
                  Text(
                    l10n.text('checker.camera.notice.title', 'Camera access is requested only when you start scanning.'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.text('checker.camera.notice.body', 'ORVIKA processes the decoded value on this device. It does not save camera frames or automatically open links, join networks, save contacts or make payments. Camera permission prompts and persistence are controlled by your browser or operating system.'),
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
                  ),
                  if (defaultTargetPlatform == TargetPlatform.android) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.text(
                        'checker.camera.androidMlKit.disclosure',
                        "On Android, barcode recognition uses Google's bundled ML Kit. Scan images and decoded barcode content are processed on this device and are not sent to Google. ML Kit may send Google diagnostics and usage metrics, including device and app details, installation identifiers, performance, configuration, event and error data. Details: developers.google.com/ml-kit/terms",
                      ),
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (kIsWeb) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.text(
                        'checker.camera.webDecoder.detail',
                        'Web scanning requires a decoder hosted by jsDelivr. Scanning may be unavailable if the CDN is blocked or offline.',
                      ),
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: Semantics(
                  container: true,
                  label: l10n.text(
                    'checker.camera.previewDescription',
                    'Camera preview. Position a QR code within the visible frame. If camera scanning is unavailable, close the scanner and use the paste-and-check option.',
                  ),
                  child: ExcludeSemantics(
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
                      errorBuilder: (context, error) {
                        // The preview subtree is excluded from semantics. Mirror
                        // this failure into the live-region status outside it.
                        _announceScannerError(error, l10n);
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.textWithParameters('checker.camera.previewError', fallback: 'Camera preview could not start. {error}', parameters: {'error': error.errorCode.name}),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_statusMessage != null) ...[
                    Semantics(
                      liveRegion: true,
                      container: true,
                      label: _statusMessage!,
                      child: ExcludeSemantics(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(color: scheme.error, height: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (!_cameraActive)
                    FilledButton.icon(
                      onPressed: _starting
                          ? null
                          : () {
                              _cameraRequested = true;
                              _startCamera();
                            },
                      icon: const Icon(Icons.no_photography_outlined),
                      label: Text(_starting
                          ? l10n.text('checker.camera.requesting', 'Requesting camera access…')
                          : l10n.text('checker.camera.allow', 'Allow camera for this scan')),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _stopCamera,
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: Text(l10n.text('checker.camera.stop', 'Stop camera')),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.text('checker.camera.formats', 'Supported formats depend on the camera, operating system and scanning backend. Unsupported devices can use the existing paste-and-check option.'),
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
