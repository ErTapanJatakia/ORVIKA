(() => {
  const SITE_KEY = '0x4AAAAAAGB8kgQ5Ag_Y6dMR';
  const API_ORIGIN = location.hostname === 'orvika.pages.dev'
    ? location.origin
    : 'https://orvika.pages.dev';
  const action = 'contact_reveal';
  const button = document.getElementById('reveal-contact');
  const status = document.getElementById('contact-status');
  const list = document.getElementById('contact-list');
  let token = '';
  let widgetId = null;

  function setStatus(message) {
    status.textContent = message;
  }

  function resetChallenge() {
    token = '';
    button.disabled = true;
    if (window.turnstile && widgetId !== null) window.turnstile.reset(widgetId);
  }

  window.onOrvikaTurnstileReady = () => {
    widgetId = window.turnstile.render('#turnstile-widget', {
      sitekey: SITE_KEY,
      action,
      callback(value) {
        token = value;
        button.disabled = false;
        setStatus('Verification complete. Select the button to request the contact details.');
      },
      'expired-callback'() {
        resetChallenge();
        setStatus('Verification expired. Please complete the challenge again.');
      },
      'error-callback'() {
        resetChallenge();
        setStatus('Verification could not load. Check your connection and try again.');
      },
      'timeout-callback'() {
        resetChallenge();
        setStatus('Verification timed out. Please try again.');
      }
    });
  };

  const script = document.createElement('script');
  script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onOrvikaTurnstileReady&render=explicit';
  script.async = true;
  script.defer = true;
  script.onerror = () => setStatus('The verification service could not be loaded. Please try again later.');
  document.head.appendChild(script);

  button.addEventListener('click', async () => {
    if (!token) return;
    button.disabled = true;
    setStatus('Verifying your request…');
    try {
      const response = await fetch(API_ORIGIN + '/api/accessibility-contact', {
        method: 'POST',
        mode: 'cors',
        credentials: 'omit',
        cache: 'no-store',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ turnstileToken: token })
      });
      const result = await response.json();
      if (!response.ok || !Array.isArray(result.emails) ||
          !result.emails.every(value => typeof value === 'string')) {
        throw new Error('Contact details are temporarily unavailable. Please try again later.');
      }
      list.replaceChildren();
      for (const email of result.emails) {
        const item = document.createElement('li');
        const link = document.createElement('a');
        link.href = 'mailto:' + email;
        link.textContent = email;
        item.appendChild(link);
        list.appendChild(item);
      }
      list.hidden = false;
      setStatus('Verification successful. You can now use the contact addresses above.');
      token = '';
      if (window.turnstile && widgetId !== null) window.turnstile.reset(widgetId);
    } catch (error) {
      list.hidden = true;
      setStatus(error instanceof Error ? error.message : 'Unable to verify the request. Please try again.');
      resetChallenge();
    }
  });
})();
