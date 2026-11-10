window.va = window.va || function () {
  (window.vaq = window.vaq || []).push(arguments);
};
(function () {
  var pathElement = document.querySelector('meta[name="vercel-analytics-script"]');
  var scriptPath = pathElement ? pathElement.getAttribute('content').trim() : '';
  if (!/^\/[A-Za-z0-9/_-]+\/script\.js$/.test(scriptPath)) return;
  var script = document.createElement('script');
  script.defer = true;
  script.src = scriptPath;
  document.head.appendChild(script);
})();
