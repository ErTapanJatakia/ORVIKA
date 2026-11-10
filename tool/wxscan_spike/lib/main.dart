import 'package:flutter/material.dart';
import 'package:wxscan/web.dart';

void main() {
  configureWxScanWeb(
    const WxScanWebPaths(
      workerUrl: 'wxscan/wxscan_worker.js',
      wasmUrl: 'wxscan/wxscan_wasm.wasm',
      tfliteUrl: 'wxscan/wxscan_tflite.js',
    ),
  );
  runApp(const _SpikeApp());
}

class _SpikeApp extends StatelessWidget {
  const _SpikeApp();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'ORVIKA wxscan feasibility',
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'wxscan Web assets configured. This isolated harness does not '
                'access the camera, upload images, or contact a scanning API.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
}
