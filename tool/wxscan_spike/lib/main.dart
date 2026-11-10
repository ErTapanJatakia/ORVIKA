import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'package:wxscan/web.dart';
import 'package:wxscan/wxscan.dart';

void main() {
  configureWxScanWeb(
    const WxScanWebPaths(
      workerUrl: 'wxscan/wxscan_worker.js',
      wasmUrl: 'wxscan/wxscan_wasm.wasm',
      tfliteUrl: './wxscan_tflite.js',
    ),
  );
  runApp(const _SpikeApp());
}

class _SpikeApp extends StatefulWidget {
  const _SpikeApp();

  @override
  State<_SpikeApp> createState() => _SpikeAppState();
}

class _SpikeAppState extends State<_SpikeApp> {
  static const _expected = 'ORVIKA-WXSCAN-FEASIBILITY-2026';
  String _status = 'WXSCAN_STATUS:LOADING';

  @override
  void initState() {
    super.initState();
    web.window.document.title = 'WXSCAN_STATUS:BOOTING';
    _runBrowserDecode();
  }

  void _setStatus(String value) {
    final status = 'WXSCAN_STATUS:$value';
    web.window.document.title = status;
    if (mounted) setState(() => _status = status);
  }

  Future<Uint8List> _asset(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> _runBrowserDecode() async {
    WxScanner? scanner;
    try {
      _setStatus('LOADING_MODELS');
      final detect = await _asset('assets/models/detect.tflite');
      final superResolution = await _asset('assets/models/sr.tflite');
      final fixture = await _asset('assets/fixtures/qr.png');
      _setStatus('CREATING_SCANNER');
      scanner = await WxScanner.create(
        detectModel: detect,
        srModel: superResolution,
      ).timeout(const Duration(seconds: 45));
      _setStatus('CHECKING_MODELS');
      if (!scanner.hasDetector || !scanner.hasSuperResolution) {
        throw StateError(
          'CNN models did not load (detector=${scanner.hasDetector}, '
          'superResolution=${scanner.hasSuperResolution})',
        );
      }
      _setStatus('SCANNING');
      final outcome = await scanner
          .scanImage(fixture)
          .timeout(const Duration(seconds: 60));
      final decoded = outcome.results.any((result) => result.text == _expected);
      if (!decoded) {
        throw StateError(
          'Synthetic QR was not decoded; results=${outcome.results.length}',
        );
      }
      _setStatus('PASS');
    } catch (error) {
      _setStatus('FAIL: $error');
    } finally {
      await scanner?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ORVIKA wxscan browser runtime test',
        home: Scaffold(
          body: Center(
            child: SelectableText(
              _status,
              key: const ValueKey('wxscan-status'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
