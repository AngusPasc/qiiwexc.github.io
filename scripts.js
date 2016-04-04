'use strict';

// Yandex Metric
(function (d, w, c) {
  (w[c] = w[c] || []).push(function () {
    try {
      w.yaCounter35198485 = new Ya.Metrika({
        accurateTrackBounce: true,
        clickmap: true,
        ecommerce: 'dataLayer',
        id: 35198485,
        trackHash: true,
        trackLinks: true,
        webvisor: true
      });
    } catch (e) { }
  });

  var n = d.getElementsByTagName('script')[0];
  var s = d.createElement('script');
  var f = function () {
    n.parentNode.insertBefore(s, n);
  };

  s.async = true;
  s.src = 'http://mc.yandex.ru/metrika/watch.js';
  s.type = 'text/javascript';

  if (w.opera === '[object Opera]') {
    d.addEventListener('DOMContentLoaded', f, false);
  } else {
    f();
  }
})(document, window, 'yandex_metrika_callbacks');

// search for drivers
document.getElementsByTagName('form')[0].onsubmit = function (event) {
  var text = document.getElementsByTagName('input')[0].value;
  event.preventDefault();

  // notify if search box is empty, otherwise - go to devid.info
  if (text.replace(new RegExp(' ', 'g'), '').length < 1) {
    window.alert('The search field is empty!');
  } else {
    window.open('http://devid.info/search?text=' + text.replace(/&/g, '%26'));
  }
};
