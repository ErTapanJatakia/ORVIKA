{{flutter_js}}
{{flutter_build_config}}

// On the isolated Cloudflare validation host, the edge middleware adds a
// per-response nonce to this external bootstrap script. Forward it to Flutter
// so engine-created inline scripts and style elements receive the same nonce.
// Other hosting targets retain the existing no-nonce initialization path.
const bootstrapScript = document.currentScript;
const cspNonce = bootstrapScript && bootstrapScript.nonce;

_flutter.loader.load({
  config: cspNonce ? { nonce: cspNonce } : {},
});
