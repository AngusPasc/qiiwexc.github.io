'use strict';

var systemArchitecture;
var systemLanguage;
var systemVersion;

// define download URLs
var urlBlueScreenViewx64 = 'http://nirsoft.net/utils/bluescreenview-x64.zip';
var urlBlueScreenViewx86 = 'http://nirsoft.net/utils/bluescreenview.zip';
var url2010Eng = 'http://drive.google.com/uc?id=0B45un_ZTihqxZmtTS2t4RUFWM0U';
var url2010Rus = 'http://drive.google.com/uc?id=0B45un_ZTihqxRS1LQkVBRXpmX00';
var url2016Eng = 'http://drive.google.com/uc?id=0B45un_ZTihqxcTd3RTdiSVVGbFU';
var url2016Rus = 'http://drive.google.com/uc?id=0B45un_ZTihqxRFEwVlAya0ZWZzQ';
var urlWXPEng = 'http://drive.google.com/uc?id=0B45un_ZTihqxM1Y0R2luQ3poMEU';
var urlWXPRus = 'http://drive.google.com/uc?id=0B45un_ZTihqxNHFWNnB1QzlzN2c';

/*
 * Handle selection events
 */

// change language helper function
var changeLanguage = function (selector, method) {
  // handle language change for different types of links
  switch (method) {
    case 0: {
      $(selector).attr('href', $(selector).attr('href').replace(/.com|.ru|.lv/, systemLanguage === 'en' ? '.com' : '.' + systemLanguage));
      return;
    }

    case 1: {
      $(selector).attr('href', $(selector).attr('href').replace(/_en|_ru|_lv/, systemLanguage === 'lv' ? '_en' : '_' + systemLanguage));
      return;
    }

    case 2: {
      $(selector).attr('href', $(selector).attr('href').replace(/\/en|\/lv|\/ru/, '/' + systemLanguage));
      return;
    }

    default: {
      return;
    }
  }
};

// set target architecture
var setArchitecture = function () {
  systemArchitecture = $('#architecture option:selected').val();

  // switch between x64 and x86 versions of BlueScreenView
  $('.BlueScreenView').attr('href', systemArchitecture === '64' ? urlBlueScreenViewx64 : urlBlueScreenViewx86);
};

// set target version
var setVersion = function () {
  systemVersion = $('#version option:selected').val();

  // handle Google dropping support of Chrome
  if (systemVersion === 'XP' || systemVersion === 'other') {
    $('#installs .Chrome').attr('href', $('#installs .Chrome').attr('href').replace('devchannel', 'betachannel'));
  } else {
    $('#installs .Chrome').attr('href', $('#installs .Chrome').attr('href').replace('betachannel', 'devchannel'));
  }

  // handle different OS versions
  switch (systemVersion) {
    case '10': {
      $('.WindowsToUSB').show();
      $('.StartMenu8').hide();
      $('.AutoKMS').show();
      $('.o2016').show();
      $('.o2010').hide();
      $('.KMS').hide();
      $('.w10').show();
      $('.w8').hide();
      $('.w7').hide();
      $('.XP').hide();
      return;
    }

    case '8': {
      $('.WindowsToUSB').show();
      $('.StartMenu8').show();
      $('.AutoKMS').show();
      $('.o2016').show();
      $('.o2010').hide();
      $('.KMS').hide();
      $('.w10').hide();
      $('.w8').show();
      $('.w7').hide();
      $('.XP').hide();
      return;
    }

    case '7': {
      $('.WindowsToUSB').show();
      $('.StartMenu8').hide();
      $('.AutoKMS').show();
      $('.o2016').show();
      $('.o2010').hide();
      $('.KMS').hide();
      $('.w10').hide();
      $('.w8').hide();
      $('.w7').show();
      $('.XP').hide();
      return;
    }

    case 'XP': {
      $('.WindowsToUSB').hide();
      $('.StartMenu8').hide();
      $('.AutoKMS').hide();
      $('.o2016').hide();
      $('.o2010').show();
      $('.KMS').show();
      $('.w10').hide();
      $('.w8').hide();
      $('.w7').hide();
      $('.XP').show();
      return;
    }

    case 'other': {
      $('.WindowsToUSB').show();
      $('.StartMenu8').show();
      $('.AutoKMS').show();
      $('.o2016').show();
      $('.o2010').show();
      $('.KMS').show();
      $('.w10').show();
      $('.w8').show();
      $('.w7').show();
      $('.XP').show();
      return;
    }

    default: {
      return;
    }
  }
};

// set target language
var setLanguage = function () {
  systemLanguage = $('#language option:selected').val();

  // switch between English and Russian versions of Office and Windows XP
  $('.XP').eq(0).attr('href', systemLanguage === 'ru' ? urlWXPRus : urlWXPEng);
  $('.o2010').eq(0).attr('href', systemLanguage === 'ru' ? url2010Rus : url2010Eng);
  $('.o2016').eq(0).attr('href', systemLanguage === 'ru' ? url2016Rus : url2016Eng);

  // change language for installers liks, specifying link element and method
  changeLanguage('#installs .Chrome', 0);
  changeLanguage('#installs .Chrome', 2);
  changeLanguage('#installs .TeamViewer', 1);

  // change language for each preferences link, specifying link element and method
  $('#preferences a').each(function (number, element) {
    changeLanguage('#preferences .' + $(element).attr('class'), 2);
  });
};

/*
 * Bind event handlers
 */

// handle user selections
$('#architecture').change(setArchitecture);
$('#version').change(setVersion);
$('#language').change(setLanguage);

// search for drivers
$('form').submit(function (event) {
  var text = $('input').val();
  event.preventDefault();

  // notify if search box is empty, otherwise - go to devid.info
  if (text.replace(new RegExp(' ', 'g'), '').length < 1) {
    window.alert('The search field is empty!');
  } else {
    window.open('http://devid.info/search?text=' + text.replace(/&/g, '%26'));
  }
});

// mark clicked elements and provide suggestions
$('.content a').click(function (event) {
  var $target = $(event.target);
  var $similar = $('.' + $target.attr('class').split(' ')[0]);

  // suggest links based on the clicked link
  switch ($target.attr('class').split(' ')[0]) {
    case 'o2010': {
      $('.KMS').addClass('suggested');
      break;
    }

    case 'o2016': {
      $('.AutoKMS').addClass('suggested');
      break;
    }

    case 'w7':
    case 'w8':
    case 'w10': {
      $('.WindowsToUSB').addClass('suggested');
      break;
    }

    default: {
      break;
    }
  }

  if ($target[0] === $similar[0]) {
    $similar.eq(1).addClass('suggested');
  }

  // mark clicked link
  $target.removeClass('suggested');
  $target.addClass('clicked');
});

/*
 * Run at startup
 */

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

// detect system architecture
if (navigator.userAgent.indexOf('WOW64') !== -1 || navigator.userAgent.indexOf('Win64') !== -1) {
  systemArchitecture = 64;
} else {
  systemArchitecture = 32;
}

// detect system language
if (navigator.language.indexOf('lv') !== -1) {
  systemLanguage = 'lv';
} else if (navigator.language.indexOf('ru') !== -1) {
  systemLanguage = 'ru';
} else {
  systemLanguage = 'en';
}

// detect system version
if (navigator.appVersion.indexOf('Windows NT 10.0') !== -1) {
  systemVersion = 10;
} else if (navigator.appVersion.indexOf('Windows NT 6.4') !== -1) {
  systemVersion = 10;
} else if (navigator.appVersion.indexOf('Windows NT 6.3') !== -1) {
  systemVersion = 8;
} else if (navigator.appVersion.indexOf('Windows NT 6.2') !== -1) {
  systemVersion = 8;
} else if (navigator.appVersion.indexOf('Windows NT 6.1') !== -1) {
  systemVersion = 7;
} else if (navigator.appVersion.indexOf('Windows NT 5.1') !== -1) {
  systemVersion = 'XP';
} else {
  systemVersion = '?';
}

// select current system parameters at startup
$('#architecture option[value=' + systemArchitecture + ']').prop('selected', true);
$('#version option[value=' + systemVersion + ']').prop('selected', true);
$('#language option[value=' + systemLanguage + ']').prop('selected', true);

// first time modifications
setArchitecture();
setVersion();
setLanguage();
