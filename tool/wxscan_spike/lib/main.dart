import 'dart:convert';
import 'dart:js_interop';

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
  WxScanner? _scanner;

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

  void _installPrivateReferencePicker() {
    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.id = 'reference-image';
    input.type = 'file';
    input.accept = 'image/*';
    input.title = 'Select a private QR reference image';
    input.setAttribute('aria-label', 'Select a private QR reference image');
    input.style.setProperty('position', 'fixed');
    input.style.setProperty('top', '16px');
    input.style.setProperty('left', '16px');
    input.style.setProperty('z-index', '2147483647');
    input.style.setProperty('padding', '8px');
    input.style.setProperty('background', '#ffffff');
    input.style.setProperty('color', '#111111');
    web.document.body?.append(input);
    input.addEventListener('change', (web.Event event) {
      final files = input.files;
      if (files == null || files.length == 0) return;
      final file = files.item(0);
      if (file == null) return;
      final reader = web.FileReader();
      reader.addEventListener('load', (web.Event _) {
        final dataUrl = (reader.result as JSString).toDart;
        final encoded = dataUrl.substring(dataUrl.indexOf(',') + 1);
        _scanPrivateReference(Uint8List.fromList(base64Decode(encoded)));
      }.toJS);
      reader.addEventListener('error', (web.Event _) {
        _setStatus('REFERENCE_READ_ERROR');
      }.toJS);
      reader.readAsDataURL(file);
    }.toJS);
  }

  Future<void> _scanPrivateReference(Uint8List bytes) async {
    final scanner = _scanner;
    if (scanner == null) {
      _setStatus('REFERENCE_SCANNER_NOT_READY');
      return;
    }
    try {
      _setStatus('REFERENCE_SCANNING');
      final outcome = await scanner
          .scanImage(bytes)
          .timeout(const Duration(seconds: 90));
      _setStatus(
        outcome.results.isEmpty
            ? 'REFERENCE_NO_DECODE'
            : 'REFERENCE_DECODED_${outcome.results.length}',
      );
    } catch (error) {
      _setStatus('REFERENCE_ERROR: $error');
    }
  }

  Future<void> _runBrowserDecode() async {
    try {
      _setStatus('LOADING_MODELS');
      final detect = await _asset('assets/models/detect.tflite');
      final superResolution = await _asset('assets/models/sr.tflite');
      final fixture = await _asset('assets/fixtures/qr.png');
      _setStatus('CREATING_SCANNER');
      final scanner = await WxScanner.create(
        detectModel: detect,
        srModel: superResolution,
      ).timeout(const Duration(seconds: 45));
      _scanner = scanner;
      _setStatus('CHECKING_MODELS');
      if (!scanner.hasDetector || !scanner.hasSuperResolution) {
        throw StateError(
          'CNN models did not load (detector=${scanner.hasDetector}, '
          'superResolution=${scanner.hasSuperResolution})',
        );
      }
      _setStatus('SCANNING_SYNTHETIC');
      final outcome = await scanner
          .scanImage(fixture)
          .timeout(const Duration(seconds: 60));
      final decoded = outcome.results.any((result) => result.text == _expected);
      if (!decoded) {
        throw StateError(
          'Synthetic QR was not decoded; results=${outcome.results.length}',
        );
      }
      _installPrivateReferencePicker();
      _setStatus('PASS');
    } catch (error) {
      _setStatus('FAIL: $error');
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
